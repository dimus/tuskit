class Feature < ActiveRecord::Base
  belongs_to :milestone
  has_many :implementations
  has_many :iterations

  has_many :stories, :through => :implementations

  validates_presence_of :name
end
