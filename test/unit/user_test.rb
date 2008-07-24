require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  def test_should_create_user
    count_before = User.send(:count)
    user = create_user
    assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    count_after = User.count
    assert count_after > count_before
  end

  def test_should_require_login
    count_before = User.count
    u = create_user(:login => nil)
    assert count_before == User.count
    assert u.errors.on(:login)
  end

  def test_should_require_password
    count_before = User.count
    u = create_user(:password => nil)
    assert count_before == User.count
    assert u.errors.on(:password)
  end

  def test_should_require_password_confirmation
    count_before = User.count
    u = create_user(:password_confirmation => nil)
    assert count_before == User.count
    assert u.errors.on(:password_confirmation)
  end

  def test_should_require_email
    count_before = User.count
    u = create_user(:email => nil)
    assert count_before == User.count
    assert u.errors.on(:email)
  end
  
  def test_should_require_first_name
    count_before = User.count
    u = create_user(:first_name => nil)
    assert count_before == User.count
    assert u.errors.on(:first_name)
  end
  
  def test_should_require_first_name
    count_before = User.count
    u = create_user(:last_name => nil)
    assert count_before == User.count
    assert u.errors.on(:last_name)
  end


  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  def test_has_project_members_and_projects
    u = users(:quentin)
    assert_not_nil u.project_members
    assert_not_nil u.projects
    assert_equal u.projects.length, u.project_members.length
    assert u.projects.length > 0
  end
  
  def test_user_full_name
    u = users(:quentin)
    assert_equal("Dorward, Quentin", u.full_name(first_name_first=false))
    assert_equal("Quentin Dorward", u.full_name);
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :first_name => "es", :last_name => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
