class SearchResults
  attr_accessor :artworks

  def initialize()
    @artworks = []
  end

  def to_h
    {
      artworks: @artworks
    }
  end
end