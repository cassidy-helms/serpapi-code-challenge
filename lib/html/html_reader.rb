require 'nokogiri'
require_relative 'html_parser'
require_relative 'json/json_exporter'
require_relative 'search_result_types/search_results'

class HtmlReader
  def read(path)
    results = SearchResults.new
    File.foreach(path) { |line|
      results = HtmlParser.parse(line, results)
    }
    results
  end
end

search_results = HtmlReader.new.read('files\van-gogh-paintings.html')
JsonExporter.new.export(search_results)