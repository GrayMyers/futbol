require_relative './game.rb'
require_relative './team.rb'
require_relative './game_team.rb'
require_relative './game_statistics.rb'
require_relative './season_statistics.rb'
require_relative './team_statistics.rb'
require_relative './league_statistics.rb'
require_relative './object_data.rb'
require 'CSV'
class StatTracker
  attr_reader :games, :teams, :game_teams
  def initialize(locations)
    @locations = locations
    @object_data ||= ObjectData.new(self)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def count_of_games_by_season #count_methods
    seasons = season_keys(@object_data.games).uniq
    games_by_season = {}
    seasons.each do |season|
      count = 0
      game_data.each do |game_id, game_obj|
        count += 1 if season == game_obj.season
      end
        games_by_season[season] = count
    end
    games_by_season
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

  def highest_total_score
    total_goals_by_game(@object_data.games).values.max
  end

  def lowest_total_score
     total_goals_by_game(@object_data.games).values.min
  end

  def percentage_home_wins
    (total_home_wins(@object_data.games) / total_games(@object_data.games).to_f).round(2)
  end

  def percentage_visitor_wins
    (total_away_wins(@object_data.games) / total_games(@object_data.games).to_f).round(2)
  end

  def percentage_ties
    (total_ties(@object_data.games) / total_games(@object_data.games).to_f).round(2)
  end

  def count_of_games_by_season
    seasons = season_keys(@object_data.games).uniq
    games_by_season = {}
    seasons.each do |season|
      count = 0
      @object_data.games.each do |game_id, game_obj|
        count += 1 if season == game_obj.season
      end
        games_by_season[season] = count
    end
    games_by_season
  end

  def average_goals_per_game
    (total_goals_by_game(@object_data.games).values.sum / total_goals_by_game(@object_data.games).count.to_f).round(2)
  end

  def average_goals_by_season
    average_goals = {}
    season_game_count = count_of_games_by_season
    @object_data.games.each do |game_id, game_obj|
      if average_goals[game_obj.season].nil?
        average_goals[game_obj.season] = game_obj.total_goals
      else
        average_goals[game_obj.season] += game_obj.total_goals
      end
    end
    average_goals.each do |season, goals|
      average_goals[season] = (goals.to_f / season_game_count[season]).round(2)
    end
    average_goals
  end

  def winningest_coach(season)
    coach_total_wins_by_season(season, @object_data.games, @object_data.game_teams).max_by do |team_id,hash|
      wins_to_percentage(hash)
    end[0]
  end

  def worst_coach(season)#season, @object_data.games, @object_data.game_teams
    coach_total_wins_by_season(season, @object_data.games, @object_data.game_teams).min_by do |team_id,hash|
      wins_to_percentage(hash)
    end[0]
  end

  def most_accurate_team(season)
    team_name(most_accurate_team_id(season, @object_data.games, @object_data.game_teams, @object_data.teams), @object_data.teams)
  end

  def least_accurate_team(season)
    team_name(least_accurate_team_id(season, @object_data.games, @object_data.game_teams, @object_data.teams), @object_data.teams)
  end

  def most_tackles(season)
    team_name(team_id_highest_tackles(season, @object_data.games, @object_data.game_teams, @object_data.teams), @object_data.teams)
  end

  def fewest_tackles(season)
    team_name(team_id_lowest_tackles(season, @object_data.games, @object_data.game_teams, @object_data.teams), @object_data.teams)
  end

  def team_info(team_id)
    team_data = @object_data.teams[team_id]
    new_hash = {
      "franchise_id" => team_data.franchiseId.to_s,
      "team_name" => team_data.teamName,
      "abbreviation" => team_data.abbreviation,
      "link" => team_data.link,
      "team_id" => team_id
    }
  end

  def best_season(team_id)
    season_wins_and_losses = add_wins_and_losses(@object_data.games, team_id)
    highest_win_to_loss = season_wins_and_losses.max_by do |season, win_and_loss_hash|
      win_and_loss_hash[:wins].to_f / win_and_loss_hash[:total]
    end
    highest_win_to_loss[0].to_s
  end

  def worst_season(team_id)
    season_wins_and_losses = add_wins_and_losses(@object_data.games, team_id)
    highest_win_to_loss = season_wins_and_losses.min_by do |season, win_and_loss_hash|
      win_and_loss_hash[:wins].to_f / win_and_loss_hash[:total]
    end
    highest_win_to_loss[0].to_s
  end

  def average_win_percentage(team_id)
    total_games = 0
    total_wins = 0
    @object_data.games.each do |game_id, game|
      home_team_won = game.home_goals > game.away_goals
      is_draw = game.home_goals == game.away_goals
      team_is_home = game.home_team_id == team_id.to_i
      team_is_playing = team_is_home || game.away_team_id == team_id.to_i
      if team_is_playing
        total_games += 1
        if (home_team_won == team_is_home) && !is_draw
          total_wins += 1
        end
      end
     end
     (total_wins / total_games.to_f).floor(2)
  end

  def most_goals_scored(team_id)
    games_by_goals(@object_data.games,team_id).max
  end

  def fewest_goals_scored(team_id)
    games_by_goals(@object_data.games,team_id).min
  end

  def favorite_opponent(team_id)
    overall_wins = team_by_win_percentage(@object_data.games, team_id).max_by do |team_id, wins_hash|
      wins_hash[:wins] / wins_hash[:total].to_f
    end
    team_name_from_id(@object_data.teams,overall_wins[0].to_s)
  end

  def rival(team_id)
    overall_wins = team_by_win_percentage(@object_data.games, team_id).min_by do |team_id, wins_hash|
      wins_hash[:wins] / wins_hash[:total].to_f
    end
    team_name_from_id(@object_data.teams,overall_wins[0].to_s)
  end

  def count_of_teams
    @object_data.teams.count
  end

  def best_offense
    team_name_from_id(@object_data.teams,highest_goals_by_team_id(@object_data.game_teams))
  end

  def worst_offense
    team_name_from_id(@object_data.teams,lowest_goals_by_team_id(@object_data.game_teams))
  end

  def highest_scoring_visitor
    team_name_from_id(@object_data.teams,best_worst_offense_defense(@object_data.games,true,"away"))
  end

  def highest_scoring_home_team
    team_name_from_id(@object_data.teams,best_worst_offense_defense(@object_data.games,true,"home"))
  end

  def lowest_scoring_visitor
    team_name_from_id(@object_data.teams,best_worst_offense_defense(@object_data.games,false,"away"))
  end

  def lowest_scoring_home_team
    team_name_from_id(@object_data.teams,best_worst_offense_defense(@object_data.games,false,"home"))
  end

  private
  #------------------------------------GAME STATISTICS
  def total_ties(game_data)
    ties = 0
    game_data.each do |game_id, game|
      ties += 1 if (game.home_goals == game.away_goals)
    end
    ties
  end

  def season_keys(game_data) #count_methods
    game_data.map do |game_id, game_obj|
      game_obj.season
    end
  end


  def total_away_wins(game_data)
    wins = 0
    game_data.each do |game_id, game|
      wins += 1 if (game.home_goals < game.away_goals)
    end
    wins
  end

  def total_home_wins(game_data)
    wins = 0
    game_data.each do |game_id, game|
      wins += 1 if (game.home_goals > game.away_goals)
    end
    wins
  end

  def total_games(game_data)
    game_data.count
  end

  def total_goals_by_game(game_data)
    all_game_scores = {}
    game_data.each do |game_id, game|
      all_game_scores[game_id] = game.total_goals
    end
    all_game_scores
  end




  #-------------------------------------------LEAGUE STATISTICS
  def highest_goals_by_team_id(game_team_data)
    total_goals_by_team(game_team_data).max_by do |team_id, goals_and_games|
      goal_to_game_ratio(goals_and_games)
    end[0]
  end

  def lowest_goals_by_team_id(game_team_data)
    total_goals_by_team(game_team_data).min_by do |team_id, goals_and_games|
      goal_to_game_ratio(goals_and_games)
    end[0]
  end

  def total_goals_by_team(game_team_data)
    goals_and_games = Hash.new {|hash, key| hash[key] = {
        goals: 0,
        games: 0
      }}
    game_team_data.each do |game_id, game_pair|
      game_pair.each do |hoa, game_obj|
        goals_and_games[game_obj.team_id][:goals] += game_obj.goals
        goals_and_games[game_obj.team_id][:games] += 1
        end
      end
     goals_and_games
  end

  def goal_to_game_ratio(hash)
    hash[:goals].to_f / hash[:games]
  end

  def best_worst_offense_defense(games,highest = true,hoa = "home")
    if highest
      hoa_goals_for_team(games,hoa).max_by do |team_id, goals_and_games|
        goal_to_game_ratio(goals_and_games)
      end[0]
    else
      hoa_goals_for_team(games,hoa).min_by do |team_id, goals_and_games|
        goal_to_game_ratio(goals_and_games)
      end[0]
    end
  end

  def hoa_goals_for_team(games,hoa)
    hoa_goals = Hash.new{|hash,key|hash[key] = {goals: 0, games: 0}}
    games.each do |game_id,game|
      if hoa == "home"
        hoa_goals[game.home_team_id][:goals] += game.home_goals
        hoa_goals[game.home_team_id][:games] += 1
      else
        hoa_goals[game.away_team_id][:goals] += game.away_goals
        hoa_goals[game.away_team_id][:games] += 1
      end
    end
    hoa_goals
  end

  def team_name_from_id(teams,id)
    teams[id.to_s].teamName
  end


  #----------------------------------------SEASON STATISTICS
  def coach_total_wins_by_season(season_str, games, game_teams)
    team_wins_by_coach = {}
    games.each do |game_id, game_obj|
      if game_obj.season == season_str
        game_pair_obj = game_teams[game_id]
        game_pair_obj.each do |hoa, game_team|
          team_wins_by_coach[game_team.head_coach] ||= {wins: 0, total: 0}
          team_wins_by_coach[game_team.head_coach][:total] += 1
          if game_team.result == "WIN"
            team_wins_by_coach[game_team.head_coach][:wins] += 1
          end
        end
      end
    end
    team_wins_by_coach
  end

  def wins_to_percentage(hash)
    hash[:wins].to_f / hash[:total]
  end

  def shots_and_goals_by_team_id(season_str, game, game_teams)
    shots_and_goals = {}
    game.each do |game_id, game_obj|
      if game_obj.season == season_str
        game_teams[game_id].each do |hoa, game_team_obj|
          shots_and_goals[game_team_obj.team_id] ||= {:goals => 0, :shots => 0}
          shots_and_goals[game_team_obj.team_id][:goals] += game_team_obj.goals
          shots_and_goals[game_team_obj.team_id][:shots] += game_team_obj.shots
        end
      end
    end
    shots_and_goals
  end

  def shot_on_goal_ratio(hash)
    hash[:goals].to_f / hash[:shots]
  end

  def most_accurate_team_id(season_str, game, game_teams, teams)
    shots_and_goals_by_team_id(season_str, game, game_teams).max_by do |team_id, goals_shots|
      shot_on_goal_ratio(goals_shots)
    end[0]
  end

  def team_name(id, teams)
    teams[id.to_s].teamName
  end

  def least_accurate_team_id(season_str, game, game_teams, teams)
    shots_and_goals_by_team_id(season_str, game, game_teams).min_by do |team_id, goals_shots|
      shot_on_goal_ratio(goals_shots)
    end[0]
  end

  def tackles_by_team_id(season_str, game, game_teams, teams)
    tackles_count = Hash.new {|hash, key| hash[key] = 0}
    game.each do |game_id_str, game_obj|
      if season_str == game_obj.season
          game_teams[game_id_str].each do |hoa, game_team_obj|
            tackles_count[game_team_obj.team_id] += game_team_obj.tackles
          end
      end
    end
    tackles_count
  end

  def team_id_highest_tackles(season_str, game, game_teams, teams)
    tackles_by_team_id(season_str, game, game_teams, teams).max_by do |team_id_str, tackle_int|
      tackle_int
    end[0]
  end

  def team_id_lowest_tackles(season_str, game, game_teams, teams)
    tackles_by_team_id(season_str, game, game_teams, teams).min_by do |team_id_str, tackle_int|
      tackle_int
    end[0]
  end


  #----------------------------------------------TEAM STATISTICS
  def add_wins_and_losses(games, team_id)
    win_percent_by_season = {}
    games.each do |game_id, game|
      win_percent_by_season[game.season] ||= {wins: 0, total: 0}
      home_team_won = game.home_goals > game.away_goals
      team_is_home = game.home_team_id == team_id.to_i
      is_draw = game.home_goals == game.away_goals
      team_is_playing = team_is_home || game.away_team_id == team_id.to_i
      if team_is_playing
        win_percent_by_season[game.season][:total] += 1
        if (home_team_won == team_is_home) && !is_draw
          win_percent_by_season[game.season][:wins] += 1
        end
      end
     end
     win_percent_by_season
  end

  def games_by_goals(games, team_id)
    goals = []
    games.each do |game_id, game|
      team_is_home = game.home_team_id == team_id.to_i
      team_is_playing = team_is_home || game.away_team_id == team_id.to_i
      if team_is_playing && team_is_home
        goals << game.home_goals
      elsif team_is_playing
        goals << game.away_goals
      end
    end
    goals
  end

  def team_by_win_percentage(games, team_id)
    percent_hash = {}
    games.each do |game_id, game|
      int_id = team_id.to_i
      home_team_won = game.home_goals > game.away_goals
      team_is_home = game.home_team_id == int_id
      is_draw = game.home_goals == game.away_goals
      if team_is_home
        opponent_id = game.away_team_id
      else
        opponent_id = game.home_team_id
      end
      team_is_playing = team_is_home || game.away_team_id == int_id
      if team_is_playing
        percent_hash[opponent_id] ||= {wins: 0, total: 0}
        percent_hash[opponent_id][:total] += 1
        if (home_team_won == team_is_home) && !is_draw
          percent_hash[opponent_id][:wins] += 1
        end
      end
     end
     percent_hash
  end

  def team_name_from_id(teams,id)
    teams[id.to_s].teamName
  end
end
