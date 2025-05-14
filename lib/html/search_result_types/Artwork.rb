class Artwork
  @@heading = 'Artworks'

  def initialize(name, year, link)
    @name = name
    @year = year
    @link = link
  end

  def self.heading
    @@heading
  end
end