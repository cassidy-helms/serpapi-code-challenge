class SearchResults
  attr_accessor :artworks, :books

  def initialize()
    @artworks = []
    @books = []
  end

  def to_h
    hash = {}
    hash[:artworks] = @artworks.map { |artwork| artwork.respond_to?(:to_h) ? artwork.to_h : artwork } unless @artworks.empty?
    hash[:books] = @books.map { |book| book.respond_to?(:to_h) ? book.to_h : book } unless @books.empty?
    hash
  end
end