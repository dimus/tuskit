class Feature < ActiveRecord::Base
  belongs_to :milestone
  has_many :stories
  has_many :iterations

  validates_presence_of :name
end
