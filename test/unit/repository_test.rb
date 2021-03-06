require File.dirname(__FILE__)+'/../test_helper'

class RepositoryTest < MiniTest::Unit::TestCase
  def setup
    @repo = Repository.new(
      short:'gary/raff',
      url:'http://github.com/gary/raff'
    )
  end

  def test_that_short_is_required
    @repo.short = nil
    refute @repo.valid?
    assert_equal :short, @repo.errors.first.first
  end

  def test_persistence_and_before_save_hook
    assert_nil @repo.webhook_url
    assert @repo.save
    refute_nil @repo.webhook_url
  end

  def test_format_of_short
    @repo.short = 'noslash'
    refute @repo.valid?
    assert_equal :short, @repo.errors.first.first
  end

  def teardown
    Repository.all.delete
  end
end
