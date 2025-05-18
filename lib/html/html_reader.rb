# frozen_string_literal: true

require 'nokogiri'
require_relative 'html_parser'
require_relative 'json/json_exporter'
require_relative 'search_result_types/search_results'

# HtmlReader reads an HTML file and parses it into structured search results.
#
# Usage:
#   reader = HtmlReader.new
#   results = reader.read('path/to/file.html')
class HtmlReader
  # Reads the HTML file at the given path and parses it into search results.
  #
  # @param path [String] the path to the HTML file
  # @return [SearchResults] the parsed search results
  def read(path)
    html = File.read(path)
    HtmlParser.parse(html)
  end
end

# Example usage:
# reader = HtmlReader.new
# painting_search_results = reader.read('files\van-gogh-paintings.html')
# book_search_results = reader.read('files\stephen-king-books.html')
# album_search_results = reader.read('files\rolling-stones-albums.html')

# exporter = JsonExporter.new
# exporter.export('files/painting-results.json', painting_search_results)
# exporter.export('files/book-results.json', book_search_results)
# exporter.export('files/album-results.json', album_search_results)
