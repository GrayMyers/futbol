require "minitest/autorun"
require "minitest/pride"
require "./lib/team_statistics"
require './lib/object_data'
require './lib/stat_tracker'
require './test/test_helper'

class TeamStatisticsTest < Minitest::Test

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
    @team_statistics = TeamStatistics.new
  end

  def test_it_exists
    assert_instance_of TeamStatistics, @team_statistics
  end

  def test_team_info
    expected16 = {"franchise_id" => "11", "team_name" => "New England Revolution", "abbreviation" => "NE", "link" => "/api/v1/teams/16", "team_id" => "16"}
    assert_equal expected16, @team_statistics.team_info(@object_data.teams, "16")
    expected18 = {
      "team_id" => "18",
      "franchise_id" => "34",
      "team_name" => "Minnesota United FC",
      "abbreviation" => "MIN",
      "link" => "/api/v1/teams/18"
    }
    assert_equal expected18, @team_statistics.team_info(@object_data.teams, "18")
  end

  def test_worst_season
    expected_worst = "20142015"
    assert_equal expected_worst, @team_statistics.worst_season(@object_data.games, "6")
  end

  def test_best_season
    expected_best = "20132014"
    assert_equal expected_best, @team_statistics.best_season(@object_data.games, "6")
  end

  def test_average_win_percentage
    assert_equal 0.49, @team_statistics.average_win_percentage(@object_data.games, "6")
  end

  def test_most_goals_scored
    assert_equal 7, @team_statistics.most_goals_scored(@object_data.games, "18")
  end

  def test_fewest_goals_scored
    assert_equal 0, @team_statistics.fewest_goals_scored(@object_data.games, "18")
  end

  def test_favorite_opponent
    assert_equal "DC United", @team_statistics.favorite_opponent(@object_data.games, @object_data.teams, "18")
  end

  def test_rival
    valid_options = ["LA Galaxy", "Houston Dash"]
    actual = @team_statistics.rival(@object_data.games, @object_data.teams, "18")
    assert valid_options.include?(actual)
  end







end
