class AddListIdColumnToUsers < ActiveRecord::Migration
	def up
		change_table :lists do |t|
			t.integer :tasks_id
		end
	end
end