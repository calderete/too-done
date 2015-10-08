class CreateTasks < ActiveRecord::Migration
	def up
		create_table  :tasks do |t|
			t.string  :name
			t.time    :due_date
			t.boolean :completed?
		end
	end

	def down
		drop_table :tasks
	end
end