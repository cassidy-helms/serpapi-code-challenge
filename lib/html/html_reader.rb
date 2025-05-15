require 'nokogiri'
require_relative 'html_parser'
require_relative 'json/json_exporter'

class HtmlReader
  def read(path)
    results = []
    File.foreach(path) { |line|
      parsed = HtmlParser.parse(line)
      results << parsed if parsed
    }
    results.flatten
  end
end

search_results = HtmlReader.new.read('files\van-gogh-paintings.html')
JsonExporter.new.export(search_results)