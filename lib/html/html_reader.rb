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

search_results = HtmlReader.new.read('files\van-gogh-paintings.html')
JsonExporter.new.export(search_results)