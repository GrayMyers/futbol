require "./test/test_helper.rb"
game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'
locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}
STAT_TRACKER = StatTracker.new(locations)
OBJECT_DATA = STAT_TRACKER.object_data

class MeanMethodsTest < Minitest::Test
  def setup
    @stat_tracker = STAT_TRACKER
    @object_data = OBJECT_DATA
    @mean = MeanMethods.new(@object_data)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of MeanMethods, @mean
  end

  def test_total_games
    assert_equal 7441, @mean.total_games
  end

  def test_count_of_games_by_season
    expected = {
      "20122013"=>806,
      "20162017"=>1317,
      "20142015"=>1319,
      "20152016"=>1321,
      "20132014"=>1323,
      "20172018"=>1355
    }
    assert_equal expected, @mean.count_of_games_by_season
  end

  def test_count_of_teams
    assert_equal 32, @mean.count_of_teams
  end

  def test_average_goals_by_season
    expected = {
      "20122013"=>4.12,
      "20162017"=>4.23,
      "20142015"=>4.14,
      "20152016"=>4.16,
      "20132014"=>4.19,
      "20172018"=>4.44
    }
    assert_equal expected, @mean.average_goals_by_season
  end

  def test_average_win_percentage
    assert_equal 0.49, @mean.average_win_percentage("6")
  end

  def test_total_ties
    assert_equal 1517, @mean.total_ties
  end

  def test_team_info
    expected16 = {"franchise_id" => "11", "team_name" => "New England Revolution", "abbreviation" => "NE", "link" => "/api/v1/teams/16", "team_id" => "16"}
    assert_equal expected16, @mean.team_info( "16")
    expected18 = {
      "team_id" => "18",
      "franchise_id" => "34",
      "team_name" => "Minnesota United FC",
      "abbreviation" => "MIN",
      "link" => "/api/v1/teams/18"
    }
    assert_equal expected18, @mean.team_info("18")
  end

  def test_percentage_visitor_wins
    assert_equal 0.36, @mean.percentage_visitor_wins
  end

  def test_total_home_wins
    assert_equal 3237, @mean.total_home_wins
  end

  def test_percentage_home_wins
    assert_equal 0.44, @mean.percentage_home_wins
  end

  def test_total_away_wins
    assert_equal 2687, @mean.total_away_wins
  end

  def test_percentage_ties
    assert_equal 0.20, @mean.percentage_ties
  end
end
