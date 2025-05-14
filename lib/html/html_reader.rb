require 'nokogiri'
require_relative 'html_parser'

class HtmlReader
  def read(path)
    File.foreach(path) { |line|
      HtmlParser.parse(line)
    }
  end
end

reader = HtmlReader.new.read('files\van-gogh-paintings.html')
