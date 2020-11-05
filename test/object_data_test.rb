require "./test/test_helper.rb"
require "minitest/autorun"
require "minitest/pride"
require "./lib/object_data.rb"

class ObjectDataTest < Minitest::Test
  def test_it_exists
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    object_data = ObjectData.new(locations)
    assert_instance_of ObjectData, object_data
  end

  def test_it_has_attributes
    game_path = './data/games.csv'
    team_path = './data/teams.csv'
    game_teams_path = './data/game_teams.csv'
    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    object_data = ObjectData.new(locations)

    object_data.games.each do |game_id, game_obj|
      assert_instance_of Game, game_obj
    end

    object_data.teams.each do |game_id, team_obj|
      assert_instance_of Team, team_obj
    end

    object_data.game_teams.each do |game_id, game_team_obj|
      assert_instance_of GameTeam, game_team_obj["home"]
      assert_instance_of GameTeam, game_team_obj["away"]
    end
    
    expected = {
      :games=>"./data/games.csv",
      :teams=>"./data/teams.csv",
      :game_teams=>"./data/game_teams.csv"
    }
    assert_equal expected, object_data.locations
  end
end
