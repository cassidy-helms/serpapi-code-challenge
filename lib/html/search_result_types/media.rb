# frozen_string_literal: true

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
