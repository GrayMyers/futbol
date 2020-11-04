require 'CSV'

class ObjectData
  attr_reader :games, :teams, :game_teams
  def initialize(locations)
    @locations = locations
    @games = retrieve_games
    @teams = retrieve_teams
    @game_teams = retrieve_game_teams
  end

  def retrieve_game_teams
    output_hash = {}
    CSV.foreach(@locations[:game_teams], headers: true) do |row|
      output_hash[row["game_id"]] = {} if !output_hash[row["game_id"]]
      output_hash[row["game_id"]][row["HoA"]] = GameTeam.new(row)
    end
    output_hash
  end

  def retrieve_games
    output_hash = {}
    CSV.foreach(@locations[:games], headers: true) do |row|
      output_hash[row["game_id"]] = Game.new(row)
    end
    output_hash
  end

  def retrieve_teams
    output_hash = {}
    CSV.foreach(@locations[:teams], headers: true) do |row|
      output_hash[row["team_id"]] = Team.new(row)
    end
    output_hash
  end
end
