# frozen_string_literal: true

# Media represents a generic search result item for artworks, books, or albums.
#
# This class is intended to be used as a base for specific media types.
#
# Usage:
#   media = Media.new(name, extensions, link, image, image_id)
#   hash = media.to_h
#
# Attributes:
#   - name: The name/title of the media item.
#   - extensions: An array of additional details (e.g., year, author).
#   - link: The full URL to the media item.
#   - image: The image URL or data for the media item.
#   - image_id: The HTML id attribute for the image, if present.
class Media
  attr_reader :name, :extensions, :link, :image, :image_id
  attr_accessor :image

  def initialize(name, extensions, link, image, image_id)
    @name = name
    @extensions = extensions
    @link = link
    @image = image
    @image_id = image_id
  end

  # Returns a hash representation of the media item, suitable for JSON export.
  #
  # @return [Hash] the media item as a hash
  def to_h
    hash = {
      name: @name,
      link: @link
    }
    hash[:extensions] = @extensions unless @extensions.nil? || @extensions.empty?
    hash[:image] = @image # could include in hash initialization, but wanted to preserve expected-array.json order
    hash
  end
end
