class Artwork
  @@heading = 'Artworks'

  def initialize(name, extensions, link)
    @name = name
    @extensions = extensions
    @link = link
  end

  def self.heading
    @@heading
  end

  def name
    @name
  end

  def extensions
    @extensions
  end

  def link
    @link
  end

  def to_h
    {
      name: @name,
      extensions: @extensions,
      link: @link
    }
  end
end