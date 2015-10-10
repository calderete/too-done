require 'pry'

module TooDone
	class Task < ActiveRecord::Base
		belongs_to :list
		belongs_to :user
		#binding.pry
	end
end