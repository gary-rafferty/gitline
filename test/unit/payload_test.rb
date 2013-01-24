require File.dirname(__FILE__)+'/../test_helper'

class PayloadTest < MiniTest::Unit::TestCase
  def setup
    @payload = Payload.new(
      before: '123abc',
      after: 'def456',
      ref: 'refs/heads/master',
      commits: [{some: 'commit'}, {and: 'another'}]
    )
  end

  def test_that_before_is_required
    @payload.before = nil
    refute @payload.valid?
    assert_equal :before, @payload.errors.first.first
  end

  def test_that_after_is_required
    @payload.after = nil
    refute @payload.valid?
    assert_equal :after, @payload.errors.first.first
  end

  def test_that_ref_is_required
    @payload.ref = nil
    refute @payload.valid?
    assert_equal :ref, @payload.errors.first.first
  end

  def test_that_commits_is_required
    @payload.commits = nil
    refute @payload.valid?
    assert_equal :commits, @payload.errors.first.first
  end

  def test_persistence
    assert @payload.save
  end

  def teardown
    Payload.all.delete
  end
end
