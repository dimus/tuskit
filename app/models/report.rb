require 'date_helpers'
class Report < ActiveRecord::Base
  extend DateHelpers
  belongs_to :iteration
end
