require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper.rb"

class GameTest < Minitest::Test

  def setup
    @row = mock()
    @row.stubs('[]').with('season').returns("20122013")
    @row.stubs('[]').with('away_team_id').returns("3")
    @row.stubs('[]').with('home_team_id').returns("6")
    @row.stubs('[]').with('away_goals').returns("2")
    @row.stubs('[]').with('home_goals').returns("3")



    @game = Game.new(@row)
  end
  # @season = row["season"]
  # @away_team_id = row["away_team_id"].to_i
  # @home_team_id = row["home_team_id"].to_i
  # @away_goals = row["away_goals"].to_i
  # @home_goals = row["home_goals"].to_i
  def test_it_exists_and_has_attributes
    assert_instance_of Game, @game

    assert_equal 2, @game.away_goals
    assert_equal 3, @game.away_team_id
    assert_equal 3, @game.home_goals
    assert_equal 6, @game.home_team_id
    assert_equal "20122013", @game.season
  end

  def test_total_goals
    assert_equal 5, @game.total_goals
  end

  def test_tie?
    assert_equal false, @game.tie?
  end
end
