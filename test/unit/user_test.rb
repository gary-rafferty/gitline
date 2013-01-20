require File.dirname(__FILE__)+'/../test_helper'

class UserTest < MiniTest::Unit::TestCase
  def setup
    @user = User.new(
      uid:123,
      email:'user@test.com',
      token:'abcdef'
    )
  end

  def test_uid_is_required
    @user.uid = nil
    refute @user.valid?
    assert_equal :uid, @user.errors.first.first
  end

  def test_email_is_required
    @user.email = nil
    refute @user.valid?
    assert_equal :email, @user.errors.first.first
  end

  def test_token_is_required
    @user.token = nil
    refute @user.valid?
    assert_equal :token, @user.errors.first.first
  end

  def test_persistence
    assert @user.save
  end

  def teardown
    User.all.delete
  end
end
