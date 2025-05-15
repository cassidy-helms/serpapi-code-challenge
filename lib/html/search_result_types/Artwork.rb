class Artwork
  attr_reader :name, :extensions, :link, :image
  @@heading = 'Artworks'

  def initialize(name, extensions, link, image)
    @name = name
    @extensions = extensions
    @link = link
    @image = image
  end

  def self.heading
    @@heading
  end

  def to_h
    {
      name: @name,
      extensions: @extensions,
      link: @link,
      image: @image
    }
  end
end