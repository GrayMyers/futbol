require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper.rb"

class GameTeamTest < Minitest::Test

  def setup
    @row = mock()
    @row.stubs('[]').with('team_id').returns("3")
    @row.stubs('[]').with('HoA').returns("away")
    @row.stubs('[]').with('result').returns("LOSS")
    @row.stubs('[]').with('settled_in').returns("OT")
    @row.stubs('[]').with('head_coach').returns("John Tortorella")
    @row.stubs('[]').with('goals').returns("2")
    @row.stubs('[]').with('tackles').returns("44")
    @row.stubs('[]').with('shots').returns("8")



    @game_team = GameTeam.new(@row)
  end
  # @season = row["season"]
  # @away_team_id = row["away_team_id"].to_i
  # @home_team_id = row["home_team_id"].to_i
  # @away_goals = row["away_goals"].to_i
  # @home_goals = row["home_goals"].to_i
  def test_it_exists_and_has_attributes
    assert_instance_of GameTeam, @game_team

    assert_equal "LOSS", @game_team.result
    assert_equal "John Tortorella", @game_team.head_coach
    assert_equal 2, @game_team.goals
    assert_equal 44, @game_team.tackles
    assert_equal 8, @game_team.shots
  end
end
