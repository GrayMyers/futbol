class CountMethods
  def initialize(data)
    @object_data = data
  end

  def count_of_games_by_season
    games_by_season = {}
    season_keys.uniq.each do |season|
      count = 0
      game_data.each do |game_id, game_obj|
        count += 1 if season == game_obj.season
      end
        games_by_season[season] = count
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
  
  #---------------------HELPERS------------------------------
  def season_keys #count_of_games_by_season
    @object_data.games.map do |game_id, game_obj|
      game_obj.season
    end
  end

end
