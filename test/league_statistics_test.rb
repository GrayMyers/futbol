require './test/test_helper.rb'

class LeagueStatisticsTest < Minitest::Test

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
    @object_data ||= ObjectData.new(@stat_tracker)
    @league_statistics = LeagueStatistics.new
  end

  def test_it_exists
    assert_instance_of LeagueStatistics, @league_statistics
  end

  def test_count_of_teams
    assert_equal 32, @league_statistics.count_of_teams(@object_data.teams)
  end

  def test_best_offense
    assert_equal "Reign FC", @league_statistics.best_offense(@object_data.game_teams,@object_data.teams)
  end

end
