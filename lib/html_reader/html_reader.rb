require 'nokogiri'

class HtmlReader
  def read(path)
    htmlLine = ""
    imageEntries = []
    File.foreach(path) { |line|
      parsedLine = Nokogiri::HTML.parse(line).css('div div a').map {|line| 
        if(line['href'] =~ /\/search/)
          puts line
          puts ""
        end
      }
    }
  end
end

reader = HtmlReader.new.read('files\van-gogh-paintings.html')
