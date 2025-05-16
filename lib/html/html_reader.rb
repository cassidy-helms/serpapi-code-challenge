require 'nokogiri'
require_relative 'html_parser'
require_relative 'json/json_exporter'
require_relative 'search_result_types/search_results'

class HtmlReader
  def read(path)
    html = File.read(path)
    HtmlParser.parse(html)
  end
end

reader = HtmlReader.new
painting_search_results = reader.read('files\van-gogh-paintings.html')
book_search_results = reader.read('files\stephen-king-books.html')
album_search_results = reader.read('files\rolling-stones-albums.html')

exporter = JsonExporter.new
exporter.export('files/painting-results.json', painting_search_results)
exporter.export('files/book-results.json', book_search_results)
exporter.export('files/album-results.json', album_search_results)