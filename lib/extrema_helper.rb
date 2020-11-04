class ExtremaHelper

  def total_goals_by_game #highest_total_score, lowest_total_score
    @object_data.games.map do |game_id, game|
      [game_id,game.total_goals]
    end.to_h
  end

  def highest_goals_by_team_id #best_offense
    total_goals_by_team.max_by do |team_id, goals_and_games|
      goal_to_game_ratio(goals_and_games)
    end[0]
  end

  def lowest_goals_by_team_id #worst_offense
    total_goals_by_team.min_by do |team_id, goals_and_games|
      goal_to_game_ratio(goals_and_games)
    end[0]
  end

  def best_worst_offense_defense(highest = true,hoa = "home") #best_worst_offense_defense
    if highest
      a = hoa_goals_for_team(hoa).max_by do |team_id, goals_and_games|
        goal_to_game_ratio(goals_and_games)
      end[0]
    else
      b = hoa_goals_for_team(hoa).min_by do |team_id, goals_and_games|
        goal_to_game_ratio(goals_and_games)
      end[0]
    end
  end

  def hoa_goals_for_team(hoa) #best_worst_offense_defense
    hoa_goals = Hash.new{|hash,key|hash[key] = {goals: 0, games: 0}}
    @object_data.games.each do |game_id,game|
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

  def coach_total_wins_by_season(season_str) #winningest_coach, worst_coach
    team_wins_by_coach = Hash.new{|hash,key|hash[key] = {wins: 0, total: 0}}
    @object_data.games.each do |game_id, game_obj|
      if game_obj.season == season_str
        @object_data.game_teams[game_id].each do |hoa, game_team|
          team_wins_by_coach[game_team.head_coach][:total] += 1
          team_wins_by_coach[game_team.head_coach][:wins] += 1 if game_team.result == "WIN"
        end
      end
    end
    team_wins_by_coach
  end

  def wins_to_percentage(hash) #winningest_coach, worst_coach
    hash[:wins].to_f / hash[:total]
  end

  def most_accurate_team_id(season_str) #most_accurate_team
    shots_and_goals_by_team_id(season_str).max_by do |team_id, goals_shots|
      shot_on_goal_ratio(goals_shots)
    end[0]
  end

  def least_accurate_team_id(season_str) #least_accurate_team
    shots_and_goals_by_team_id(season_str).min_by do |team_id, goals_shots|
      shot_on_goal_ratio(goals_shots)
    end[0]
  end

  def shots_and_goals_by_team_id(season_str) #most_accurate_team, least_accurate_team
    shots_and_goals = {}
    @object_data.games.each do |game_id, game_obj|
      if game_obj.season == season_str
        @object_data.game_teams[game_id].each do |hoa, game_team_obj|
          shots_and_goals[game_team_obj.team_id] ||= {:goals => 0, :shots => 0}
          shots_and_goals[game_team_obj.team_id][:goals] += game_team_obj.goals
          shots_and_goals[game_team_obj.team_id][:shots] += game_team_obj.shots
        end
      end
    end
    shots_and_goals
  end

  def team_name(id) #all
    @object_data.teams[id.to_s].teamName
  end

  def shot_on_goal_ratio(hash)
    hash[:goals].to_f / hash[:shots]
  end

  def team_id_highest_tackles(season_str) #highest_tackles
    tackles_by_team_id(season_str).max_by do |team_id_str, tackle_int|
      tackle_int
    end[0]
  end

  def team_id_lowest_tackles(season_str) #lowest_tackles
    tackles_by_team_id(season_str).min_by do |team_id_str, tackle_int|
      tackle_int
    end[0]
  end

  def tackles_by_team_id(season_str) #highest_tackles, lowest_tackles
    tackles_count = Hash.new {|hash, key| hash[key] = 0}
    @object_data.games.each do |game_id_str, game_obj|
      if season_str == game_obj.season
          @object_data.game_teams[game_id_str].each do |hoa, game_team_obj|
            tackles_count[game_team_obj.team_id] += game_team_obj.tackles
          end
        end
      end
      tackles_count
    end

    def add_wins_and_losses(team_id) #best_season, worst_season
      win_percent_by_season = Hash.new{|hash,key|hash[key] = {wins: 0, total: 0}}
      @object_data.games.each do |game_id, game|
        home_team_won = game.home_goals > game.away_goals
        team_is_home = game.home_team_id == team_id.to_i
        team_is_playing = team_is_home || game.away_team_id == team_id.to_i
        if team_is_playing
          win_percent_by_season[game.season][:total] += 1
          win_percent_by_season[game.season][:wins] += 1 if (home_team_won == team_is_home) && !game.tie?
        end
      end
      win_percent_by_season
    end

    def games_by_goals(team_id) #most_goals_scored, fewest_goals_scored
      @object_data.games.map do |game_id, game|
        team_is_home = game.home_team_id == team_id.to_i
        team_is_playing = team_is_home || game.away_team_id == team_id.to_i
        if team_is_playing && team_is_home
          game.home_goals
        elsif team_is_playing
          game.away_goals
        end
      end.compact
    end

    def total_goals_by_team
      goals_and_games = Hash.new {|hash, key| hash[key] = {
        goals: 0,
        games: 0
        }}
        @object_data.game_teams.each do |game_id, game_pair|
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

      def team_by_win_percentage( team_id)
        percent_hash = Hash.new{|hash,key|hash[key] = {wins: 0, total: 0}}
        @object_data.games.each do |game_id, game|
          home_team_won = game.home_goals > game.away_goals
          team_is_home = game.home_team_id == team_id.to_i
          opponent_id = team_is_home ? game.away_team_id : game.home_team_id
          team_is_playing = team_is_home || game.away_team_id == team_id.to_i
          if team_is_playing
            percent_hash[opponent_id][:total] += 1
            percent_hash[opponent_id][:wins] += 1 if (home_team_won == team_is_home) && !game.tie?
          end
        end
        percent_hash
      end

end
