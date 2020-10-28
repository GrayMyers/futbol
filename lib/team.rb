class Team
  attr_reader :teamName,
              :franchiseId,
              :abbreviation,
              :link,
              :Stadium
  def initialize(row)
    @franchiseId = row[1]
    @teamName = row[2]
    @abbreviation = row[3]
    @Stadium = row[4]
    @link = row[5]
  end
end
