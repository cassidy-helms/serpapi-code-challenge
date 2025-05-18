# frozen_string_literal: true

# Album represents an artwork search result.  Child of MediaType
#
# Usage:
#   artwork = Artwork.new(name, extensions, link, image, image_id)
#   heading = Artwork.heading
class Artwork
  @heading = 'Artworks'

  class << self
    attr_reader :heading
  end
end
