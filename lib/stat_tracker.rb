require_relative './game.rb'
require_relative './team.rb'
require_relative './game_team.rb'
require_relative './mean.rb'
require_relative './extrema.rb'
require_relative './object_data.rb'

class StatTracker
  attr_reader :games, :teams, :game_teams, :object_data
  def initialize(locations)
    @locations = locations
    @object_data = ObjectData.new(locations)
    @mean = MeanMethods.new(@object_data)
    @extrema = ExtremaMethods.new(@object_data)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def count_of_games_by_season #count_methods
    @mean.count_of_games_by_season
  end

  def highest_total_score
    @extrema.highest_total_score
  end

  def lowest_total_score
     @extrema.lowest_total_score
  end

  def percentage_home_wins
    @mean.percentage_home_wins
  end

  def percentage_visitor_wins
    @mean.percentage_visitor_wins
  end

  def percentage_ties
    @mean.percentage_ties
  end

  def average_goals_per_game
    @mean.average_goals_per_game
  end

  def average_goals_by_season
    @mean.average_goals_by_season
  end

  def winningest_coach(season)
    @extrema.winningest_coach(season)
  end

  def worst_coach(season)
    @extrema.worst_coach(season)
  end

  def most_accurate_team(season)
    @extrema.most_accurate_team(season)
  end

  def least_accurate_team(season)
    @extrema.least_accurate_team(season)
  end

  def most_tackles(season)
    @extrema.most_tackles(season)
  end

  def fewest_tackles(season)
    @extrema.fewest_tackles(season)
  end

  def team_info(team_id)
    @mean.team_info(team_id)
  end

  def best_season(team_id)
    @extrema.best_season(team_id)
  end

  def worst_season(team_id)
    @extrema.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @mean.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @extrema.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @extrema.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @extrema.favorite_opponent(team_id)
  end

  def total_goals_by_game
    @extrema.total_goals_by_game
  end

  def rival(team_id)
    @extrema.rival(team_id)
  end

  def count_of_teams
    @mean.count_of_teams
  end

  def best_offense
    @extrema.best_offense
  end

  def worst_offense
    @extrema.worst_offense
  end

  def highest_scoring_visitor
    @extrema.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @extrema.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @extrema.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @extrema.lowest_scoring_home_team
  end
  
end
