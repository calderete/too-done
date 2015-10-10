require 'pry'

module TooDone
	class Task < ActiveRecord::Base
		belongs_to :list
		
		def show_all_tasks
			display = self.select(completed?: false)
			puts "#{display}"
		end
		binding.pry
	end
end