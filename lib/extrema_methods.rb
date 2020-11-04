require_relative "./extrema_helper.rb"

class ExtremaMethods < ExtremaHelper

  def initialize(data)
    @object_data = data
  end

  def highest_total_score
    total_goals_by_game.values.max
  end

  def lowest_total_score
     total_goals_by_game.values.min
  end

  def best_offense
    team_name(highest_goals_by_team_id)
  end

  def worst_offense
    team_name(lowest_goals_by_team_id)
  end

  def highest_scoring_visitor
    team_name(best_worst_offense_defense(true,"away"))
  end

  def highest_scoring_home_team
    team_name(best_worst_offense_defense(true,"home"))
  end

  def lowest_scoring_visitor
    team_name(best_worst_offense_defense(false,"away"))
  end

  def lowest_scoring_home_team
    team_name(best_worst_offense_defense(false,"home"))
  end

  def winningest_coach(season)
    coach_total_wins_by_season(season).max_by do |team_id,hash|
      wins_to_percentage(hash)
    end[0]
  end

  def worst_coach(season)
    coach_total_wins_by_season(season).min_by do |team_id,hash|
      wins_to_percentage(hash)
    end[0]
  end

  def most_accurate_team(season)
    team_name(most_accurate_team_id(season))
  end

  def least_accurate_team(season)
    team_name(least_accurate_team_id(season))
  end

  def most_tackles(season)
    team_name(team_id_highest_tackles(season))
  end

  def fewest_tackles(season)
    team_name(team_id_lowest_tackles(season))
  end

  def best_season(team_id)
    add_wins_and_losses(team_id).max_by do |season, win_and_loss_hash|
      win_and_loss_hash[:wins].to_f / win_and_loss_hash[:total]
    end[0].to_s
  end

  def worst_season(team_id)
    add_wins_and_losses(team_id).min_by do |season, win_and_loss_hash|
      win_and_loss_hash[:wins].to_f / win_and_loss_hash[:total]
    end[0].to_s
  end

  def most_goals_scored(team_id)
    games_by_goals(team_id).max
  end

  def fewest_goals_scored(team_id)
    games_by_goals(team_id).min
  end

  def favorite_opponent(team_id)
    overall_wins = team_by_win_percentage(team_id).max_by do |team_id, wins_hash|
      wins_hash[:wins].to_f / wins_hash[:total]
    end
    team_name(overall_wins[0].to_s)
  end

  def rival(team_id)
    overall_wins = team_by_win_percentage(team_id).min_by do |team_id, wins_hash|
      wins_hash[:wins].to_f / wins_hash[:total]
    end
    team_name(overall_wins[0].to_s)
  end

end
