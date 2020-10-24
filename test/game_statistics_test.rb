require 'minitest/autorun'
require 'minitest/pride'
require './lib/game_statistics'
require './lib/object_data'
require './lib/stat_tracker'

class GameStatisticsTest < Minitest::Test
  def setup
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    @stat_tracker = StatTracker.from_csv(locations)
    @object_data = ObjectData.new(@stat_tracker)
    @game_statistics = GameStatistics.new
  end

  def test_it_exists
    assert_instance_of GameStatistics, @game_statistics
  end

  def test_highest_total_score
    assert_equal 11, @game_statistics.highest_total_score(@object_data.games)
  end

  def test_total_goals_by_game
    assert_equal 6, @game_statistics.total_goals_by_game(@object_data.games)["2017030235"]
    assert_equal 3, @game_statistics.total_goals_by_game(@object_data.games)["2015030235"]
    assert_equal 7441,  @game_statistics.total_goals_by_game(@object_data.games).size
  end
end
