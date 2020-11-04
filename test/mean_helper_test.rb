require "./test/test_helper.rb"
game_path = './data/games.csv'
team_path = './data/teams.csv'
game_teams_path = './data/game_teams.csv'
locations = {
  games: game_path,
  teams: team_path,
  game_teams: game_teams_path
}
STAT_TRACKER ||= StatTracker.new(locations)
OBJECT_DATA ||= STAT_TRACKER.object_data

class MeanHelperTest < Minitest::Test
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

  def test_total_ties
    assert_equal 1517, @mean.total_ties
  end


end
