require "minitest/autorun"
require "minitest/pride"
require "./test/test_helper.rb"

class TeamTest < Minitest::Test

  def setup
    @row = mock()
    @row.stubs('[]').with('team_id').returns("1")
    @row.stubs('[]').with('franchiseId').returns("23")
    @row.stubs('[]').with('teamName').returns("Atlanta United")
    @row.stubs('[]').with('abbreviation').returns("ATL")
    @row.stubs('[]').with('Stadium').returns("Mercedes-Benz Stadium")
    @row.stubs('[]').with('link').returns("/api/v1/teams/1")


    @team = Team.new(@row)
  end
  # @season = row["season"]
  # @away_team_id = row["away_team_id"].to_i
  # @home_team_id = row["home_team_id"].to_i
  # @away_goals = row["away_goals"].to_i
  # @home_goals = row["home_goals"].to_i
  def test_it_exists_and_has_attributes
    assert_instance_of Team, @team
    assert_equal "23", @team.franchiseId
    assert_equal "Atlanta United", @team.teamName
    assert_equal "ATL", @team.abbreviation
    assert_equal "Mercedes-Benz Stadium", @team.Stadium
    assert_equal "/api/v1/teams/1", @team.link
  end
end
