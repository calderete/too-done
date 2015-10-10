module TooDone
  class User < ActiveRecord::Base
    has_many :sessions
    has_many :lists
    has_many :tasks
  end
end
