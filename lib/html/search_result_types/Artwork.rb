class Artwork
  @@heading = 'Artworks'
  @@number_of_fields = 3

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
end