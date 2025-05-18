# frozen_string_literal: true

# SearchResults holds arrays of parsed search result items for media types
#
# Usage:
#   results = SearchResults.new
#   results.artworks << Artwork.new(...)
#   results.books << Book.new(...)
#   results.albums << Album.new(...)
#   hash = results.to_h
class SearchResults
  attr_accessor :artworks, :books, :albums

  def initialize
    @artworks = []
    @books = []
    @albums = []
  end

  # Converts the search results to a hash, including only non-empty result types.
  #
  # @return [Hash] the search results as a hash suitable for JSON export
  def to_h
    hash = {}
    add_results(hash, :artworks, @artworks)
    add_results(hash, :books, @books)
    add_results(hash, :albums, @albums)
    hash
  end

  # Adds a non-empty collection to the given hash under the specified key.
  #
  # Each item in the collection is converted to a hash using its #to_h method if available.
  # If the collection is empty, nothing is added to the hash.
  #
  # @param hash [Hash] the hash to add results to
  # @param key [Symbol] the key under which to store the collection
  # @param collection [Array] the collection of items to add
  def add_results(hash, key, collection)
    return if collection.empty?

    hash[key] = collection.map { |item| item.respond_to?(:to_h) ? item.to_h : item }
  end
  private :add_results
end
