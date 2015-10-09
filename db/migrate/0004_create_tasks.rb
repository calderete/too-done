class CreateTasks < ActiveRecord::Migration
	def up
		create_table  :tasks do |t|
			t.string  :name
			t.date    :due_date
			t.boolean :completed?
			t.integer :list_id
		end
	end

	def down
		drop_table :tasks
	end
end