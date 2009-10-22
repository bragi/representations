class User < ActiveRecord::Base
  has_one :profile
  has_many :tasks
  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :tasks
end
