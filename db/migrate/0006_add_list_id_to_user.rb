class AddListIdToUser < ActiveRecord::Migration
	def up
		change_table :users do |t|
			t.integer :list_id
		end
	end
end