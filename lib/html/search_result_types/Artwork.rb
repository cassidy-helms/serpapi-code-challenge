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

  def name
    @name
  end

  def year
    @year
  end

  def link
    @link
  end

  def to_h
    {
      name: @name,
      year: @year,
      link: @link
    }
  end
end