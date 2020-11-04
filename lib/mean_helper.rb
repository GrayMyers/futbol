class MeanHelper

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
