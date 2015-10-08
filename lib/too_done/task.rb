module TooDone
	class Task < ActiveRecord::Base
		belongs_to :user
		belongs_to :list
	end
end