class MeanMethods
  def initialize(data)
    @object_data = data
  end

  def percentage_home_wins
    (total_home_wins / total_games.to_f).round(2)
  end

  def percentage_away_wins
    (total_away_wins / total_games.to_f).round(2)
  end

  def percentage_ties
    (total_ties / total_games.to_f).round(2)
  end

  def average_goals_per_game
    (total_goals_by_game.values.sum / total_goals_by_game.count.to_f).round(2)
  end

  def count_of_games_by_season #average_goals_by_season
    games_by_season = {}
    @object_data.games.each do |game_id,game_obj|
      games_by_season[game_obj.season] ||= 0
      games_by_season[game_obj.season] += 1
    end
    games_by_season
  end

  def count_of_teams
    @object_data.teams.count
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

  def average_win_percentage(team_id)
    total_games = 0
    total_wins = 0
    @object_data.games.each do |game_id, game|
      home_team_won = game.home_goals > game.away_goals
      team_is_home = game.home_team_id == team_id.to_i
      team_is_playing = team_is_home || game.away_team_id == team_id.to_i
      if team_is_playing
        total_games += 1
        if (home_team_won == team_is_home) && !game.tie?
          total_wins += 1
        end
      end
     end
     (total_wins / total_games.to_f).floor(2)
  end

  def average_goals_by_season
    average_goals = {}
    season_game_count = count_of_games_by_season
    @object_data.games.each do |game_id, game_obj|
      average_goals[game_obj.season] ||= 0
      average_goals[game_obj.season] += game_obj.total_goals
    end
    average_goals.map do |season, goals|
      [season, (goals.to_f / season_game_count[season]).round(2)]
    end.to_h
  end

  #---------------------HELPERS------------------------------
  def total_away_wins#percentage_away_wins
    wins = 0
    @object_data.games.each do |game_id, game|
      wins += 1 if (game.home_goals < game.away_goals)
    end
    wins
  end

  def total_home_wins #percentage_home_wins
    wins = 0
    @object_data.games.each do |game_id, game|
      wins += 1 if (game.home_goals > game.away_goals)
    end
    wins
  end

  def total_games #total_home_wins, total_away_wins
    @object_data.games.count
  end

  def total_ties #percentage_ties
    @object_data.games.find_all do |game_id, game|
      game.tie?
    end.count
  end

  def total_goals_by_game #average_goals_per_game
    all_game_scores = {}
    @object_data.games.each do |game_id, game|
      all_game_scores[game_id] = game.total_goals
    end
    all_game_scores
  end
end
