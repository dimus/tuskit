require File.dirname(__FILE__) + '/../test_helper'

class GroupTest < Test::Unit::TestCase
  fixtures :groups, :users, :memberships, :trackers, :projects, :project_members

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end