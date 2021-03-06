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

class ExtremaMethodsTest < Minitest::Test
  def setup
    @stat_tracker = STAT_TRACKER
    @object_data = OBJECT_DATA
    @extrema = ExtremaMethods.new(@object_data)
  end

  def test_it_exists_and_has_attributes
    assert_instance_of ExtremaMethods, @extrema
  end

  def test_best_offense
    assert_equal "Reign FC", @extrema.best_offense
  end

  def test_worst_offense
    assert_equal "Utah Royals FC", @extrema.worst_offense
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @extrema.highest_scoring_visitor
  end

  def test_lowest_scoring_visitor
    assert_equal "San Jose Earthquakes", @extrema.lowest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Reign FC", @extrema.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team
    assert_equal "Utah Royals FC", @extrema.lowest_scoring_home_team
  end

  def test_winningest_coach
   assert_equal "Claude Julien", @extrema.winningest_coach("20132014")
   assert_equal "Alain Vigneault", @extrema.winningest_coach("20142015")
  end


#diff checker: files identical. Copied expected from RV. Ask for help(?)
  def test_team_total_wins_by_season
      expected = {"Joel Quenneville"=>{:wins=>47, :total=>101}, "Ken Hitchcock"=>{:wins=>37, :total=>88}, "Mike Yeo"=>{:wins=>37, :total=>95}, "Patrick Roy"=>{:wins=>36, :total=>89}, "Darryl Sutter"=>{:wins=>53, :total=>108}, "Bruce Boudreau"=>{:wins=>49, :total=>95}, "Lindy Ruff"=>{:wins=>34, :total=>88}, "John Tortorella"=>{:wins=>33, :total=>82}, "Craig Berube"=>{:wins=>34, :total=>86}, "Mike Babcock"=>{:wins=>31, :total=>87}, "Todd Richards"=>{:wins=>38, :total=>88}, "Adam Oates"=>{:wins=>22, :total=>82}, "Bob Hartley"=>{:wins=>24, :total=>82}, "Barry Trotz"=>{:wins=>31, :total=>82}, "Claude Julien"=>{:wins=>54, :total=>94}, "Michel Therrien"=>{:wins=>44, :total=>99}, "Dan Bylsma"=>{:wins=>46, :total=>95}, "Jack Capuano"=>{:wins=>22, :total=>82}, "Claude Noel"=>{:wins=>13, :total=>47}, "Jon Cooper"=>{:wins=>29, :total=>86}, "Kevin Dineen"=>{:wins=>3, :total=>16}, "Todd McLellan"=>{:wins=>41, :total=>89}, "Ted Nolan"=>{:wins=>13, :total=>62}, "Randy Carlyle"=>{:wins=>22, :total=>82}, "Dave Tippett"=>{:wins=>28, :total=>82}, "Peter DeBoer"=>{:wins=>31, :total=>82}, "Peter Horachek"=>{:wins=>15, :total=>66}, "Paul Maurice"=>{:wins=>12, :total=>35}, "Paul MacLean"=>{:wins=>24, :total=>82}, "Dallas Eakins"=>{:wins=>19, :total=>82}, "Alain Vigneault"=>{:wins=>49, :total=>107}, "Kirk Muller"=>{:wins=>31, :total=>82}, "Ron Rolston"=>{:wins=>2, :total=>20}, "Peter Laviolette"=>{:wins=>0, :total=>3}}
      assert_equal expected, @extrema.coach_total_wins_by_season("20132014")
  end

  def test_worst_coach
    assert_equal "Peter Laviolette" ,@extrema.worst_coach("20132014")
    expected = ["Ted Nolan", "Craig MacTavish"]
    assert expected.include?(@extrema.worst_coach("20142015"))
  end

  def test_most_accurate_team
    assert_equal "Real Salt Lake", @extrema.most_accurate_team("20132014")
    assert_equal "Toronto FC", @extrema.most_accurate_team("20142015")
  end

  def test_shots_and_goals_by_team_id
    expected = {
      16=>{:goals=>237, :shots=>779},
      19=>{:goals=>193, :shots=>620},
      30=>{:goals=>184, :shots=>606},
      21=>{:goals=>193, :shots=>613},
      26=>{:goals=>232, :shots=>819},
      24=>{:goals=>232, :shots=>693},
      25=>{:goals=>199, :shots=>663},
      23=>{:goals=>161, :shots=>604},
      4=>{:goals=>185, :shots=>633},
      17=>{:goals=>177, :shots=>615},
      29=>{:goals=>188, :shots=>626},
      15=>{:goals=>161, :shots=>571},
      20=>{:goals=>164, :shots=>518},
      18=>{:goals=>166, :shots=>565},
      6=>{:goals=>220, :shots=>718},
      8=>{:goals=>198, :shots=>667},
      5=>{:goals=>209, :shots=>688},
      2=>{:goals=>178, :shots=>604},
      52=>{:goals=>175, :shots=>595},
      14=>{:goals=>188, :shots=>611},
      13=>{:goals=>154, :shots=>583},
      28=>{:goals=>203, :shots=>741},
      7=>{:goals=>136, :shots=>507},
      10=>{:goals=>170, :shots=>543},
      27=>{:goals=>172, :shots=>595},
      1=>{:goals=>157, :shots=>513},
      9=>{:goals=>171, :shots=>648},
      22=>{:goals=>155, :shots=>520},
      3=>{:goals=>222, :shots=>822},
      12=>{:goals=>167, :shots=>611}
    }
    assert_equal expected, @extrema.shots_and_goals_by_team_id("20132014")
  end

  def test_shot_on_goal_ratio
    dummy_data = {:goals => 200, :shots => 400}
    assert_equal 0.5, @extrema.shot_on_goal_ratio(dummy_data)
  end

  def test_wins_to_percentage
    dummy_data = {:wins => 300, :total => 400}
    assert_equal 0.75, @extrema.wins_to_percentage(dummy_data)
  end

  def test_least_accurate_team
    assert_equal "New York City FC", @extrema.least_accurate_team("20132014")
    assert_equal "Columbus Crew SC", @extrema.least_accurate_team("20142015")
  end

  def test_least_accurate_team_id
    assert_equal 9, @extrema.least_accurate_team_id("20132014")
    assert_equal 53, @extrema.least_accurate_team_id("20142015")
  end

  def test_most_accurate_team_id
    assert_equal 24, @extrema.most_accurate_team_id("20132014")
    assert_equal 20, @extrema.most_accurate_team_id("20142015")
  end

  def test_most_tackles
    assert_equal "FC Cincinnati", @extrema.most_tackles("20132014")
    assert_equal "Seattle Sounders FC", @extrema.most_tackles("20142015")
  end

  def test_tackles_by_team_id
    expected = {
      16=>1836,
      19=>2087,
      30=>1787,
      21=>2223,
      26=>3691,
      24=>2515,
      25=>1820,
      23=>1710,
      4=>2404,
      17=>1783,
      29=>2915,
      15=>1904,
      20=>1708,
      18=>1611,
      6=>2441,
      8=>2211,
      5=>2510,
      2=>2092,
      52=>2313,
      14=>1774,
      13=>1860,
      28=>1931,
      7=>1992,
      10=>2592,
      27=>2173,
      1=>1568,
      9=>2351,
      22=>1751,
      3=>2675,
      12=>1807
    }
    assert_equal expected, @extrema.tackles_by_team_id("20132014")
  end

  def test_team_id_highest_tackles
    assert_equal 26, @extrema.team_id_highest_tackles("20132014")
  end

  def test_team_id_lowest_tackles
    assert_equal 1, @extrema.team_id_lowest_tackles("20132014")
  end

  def test_fewest_tackles
    assert_equal "Atlanta United", @extrema.fewest_tackles("20132014")
    assert_equal "Orlando City SC", @extrema.fewest_tackles("20142015")
  end

  def test_highest_total_score
    assert_equal 11, @extrema.highest_total_score
  end

  def test_lowest_total_score
    assert_equal 0, @extrema.lowest_total_score
  end

  def test_total_goals_by_game
    assert_equal 6, @extrema.total_goals_by_game["2017030235"]
    assert_equal 3, @extrema.total_goals_by_game["2015030235"]
    assert_equal 7441, @extrema.total_goals_by_game.size
  end

  def test_worst_season
    expected_worst = "20142015"
    assert_equal expected_worst, @extrema.worst_season("6")
  end

  def test_best_season
    expected_best = "20132014"
    assert_equal expected_best, @extrema.best_season("6")
  end

  def test_most_goals_scored
    assert_equal 7, @extrema.most_goals_scored("18")
  end

  def test_fewest_goals_scored
    assert_equal 0, @extrema.fewest_goals_scored("18")
  end

  def test_favorite_opponent
    assert_equal "DC United", @extrema.favorite_opponent("18")
  end

  def test_rival
    valid_options = ["LA Galaxy", "Houston Dash"]
    actual = @extrema.rival("18")
    assert valid_options.include?(actual)
  end
end
