# frozen_string_literal: true

class SearchResults
  attr_accessor :artworks, :books, :albums

  def initialize
    @artworks = []
    @books = []
    @albums = []
  end

  def to_h
    hash = {}
    unless @artworks.empty?
      hash[:artworks] = @artworks.map do |artwork|
        artwork.respond_to?(:to_h) ? artwork.to_h : artwork
      end
    end
    hash[:books] = @books.map { |book| book.respond_to?(:to_h) ? book.to_h : book } unless @books.empty?
    hash[:albums] = @albums.map { |album| album.respond_to?(:to_h) ? album.to_h : album } unless @albums.empty?
    hash
  end
end
