class SearchResults
  attr_accessor :artworks

  def initialize()
    @artworks = []
  end

  def to_h
    {
      artworks: @artworks.map { |artwork| artwork.respond_to?(:to_h) ? artwork.to_h : artwork }
    }
  end
end