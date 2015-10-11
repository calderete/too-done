require "too_done/version"
require "too_done/init_db"
require "too_done/user"
require "too_done/session"
require "too_done/list"
require "too_done/task"

require "thor"
require "pry"
 
module TooDone
  class App < Thor

    desc "add 'TASK'", "Add a TASK to a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list which the task will be filed under."
    option :date, :aliases => :d,
      :desc => "A Due Date in YYYY-MM-DD format."
    def add(task)
      # find or create the right todo list
      # create a new item under that list, with optional date
      list = List.find_or_create_by(name: options[:list], 
                                    user_id: current_user.id)

      if options[:date] == !nil
          item = Task.create(name: task, 
                          due_date: Date.parse(options[:date]),
                          list_id: list.id)
     
      else
          item = Task.create(name: task, due_date: Date.today,
                          list_id: list.id)
      end              
    end

    desc "edit", "Edit a task from a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be edited."
    def edit
      # find the right todo list
      # BAIL if it doesn't exist and have tasks    
      # display the tasks and prompt for which one to edit
      # allow the user to change the title, due date
      #find_list = List.find_by(name: task.id)
      puts "Which task to you wish to edit"
      task_name = STDIN.gets.chomp
      show_tasks = Task.where(name: task_name)
      puts "Which tasks would you like to edit? #{show_tasks}"
      until Task.exists?(name: task_name)
        puts "#{task_name} does not exist: please enter a valid name"
        task_name = STDIN.gets.chomp
        end
        puts "What would you like change with #{task_name}"
        puts "Choose 'name' or 'due date'"
        choice = STDIN.gets.chomp.downcase
        if choice == "name"
          puts "What would you like to rename #{task_name}?"
          new_name = STDIN.gets.chomp.downcase
          new_task_name = Task.find_by(name: task_name)
          new_task_name.update(name: new_name)
        elsif choice == "due date"
          puts "What you like to change the due date to"
          puts "must be in YYYY-MM-DD formate"
          new_date = STDIN.gets.chomp.to_i
          new_due_date = Task.find_by(name: task_name)
          new_due_date.update(due_date: new_date)
        else
          puts "That is not a valid date"
        end
  #binding.pry

    end

    #def show_all_tasks
    #  display = Task.find_by(name: run)
    #  puts "#{display}"
    #binding.pry
    #end

    desc "done", "Mark a task as completed."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be completed."
    def done
      # find the right todo list
      # BAIL if it doesn't exist and have tasks
      # display the tasks and prompt for which one(s?) to mark done
      
      show_list = List.all 
      show_list.map do |t|
        puts "Chose the list number that contians the task 
            you wish to mark as done"
        puts "List: #{t.name}"
      end
      show = Task.all
      show.map do |t|
        puts "Task: #{t.name} Complete?: #{t.completed?} list id:#{t.list_id}"
      end
      puts "Which task do you want to mark as done"
      task = STDIN.gets.chomp.downcase
      mark_done = Task.find_by(name: task)
      mark_done.update(completed?: true)

    end

    desc "show", "Show the tasks on a todo list in reverse order."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be shown."
    option :completed, :aliases => :c, :default => false, :type => :boolean,
      :desc => "Whether or not to show already completed tasks."
    option :sort, :aliases => :s, :enum => ['history', 'overdue'],
      :desc => "Sorting by 'history' (chronological) or 'overdue'.
      \t\t\t\t\tLimits results to those with a due date."
    def show
      # find or create the right todo list
      # show the tasks ordered as requested, default to reverse order (recently entered first)
       
       show = Task.all
       show.map do |t| 
        puts "Task: #{t.name}, Due date: #{t.due_date},
              completed?: #{t.completed?}, List num: #{t.list_id}"
      end
      
    end

    desc "delete [LIST OR USER]", "Delete a todo list or a user."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list which will be deleted (including items)."
    option :user, :aliases => :u,
      :desc => "The user which will be deleted (including lists and items)."
    def delete
      # BAIL if both list and user options are provided
      # BAIL if neither list or user option is provided
      # find the matching user or list
      # BAIL if the user or list couldn't be found
      # delete them (and any dependents)
    end

    desc "switch USER", "Switch session to manage USER's todo lists."
    def switch(username)
      user = User.find_or_create_by(name: username)
      user.sessions.create
    end

    private
    def current_user
      Session.last.user
    end
  end
end

# binding.pry
TooDone::App.start(ARGV)
