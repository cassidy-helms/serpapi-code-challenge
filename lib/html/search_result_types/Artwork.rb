class Artwork
  attr_reader :name, :extensions, :link, :image, :image_id
  attr_accessor :image
  @@heading = 'Artworks'

  def initialize(name, extensions, link, image, image_id)
    @name = name
    @extensions = extensions
    @link = link
    @image = image
    @image_id = image_id
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