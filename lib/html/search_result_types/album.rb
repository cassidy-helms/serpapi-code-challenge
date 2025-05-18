# frozen_string_literal: true

# Album represents a music album search result.  Child of MediaType
#
# Usage:
#   album = Album.new(name, extensions, link, image, image_id)
#   heading = Album.heading
class Album
  @heading = 'Albums'

  class << self
    attr_reader :heading
  end
end
