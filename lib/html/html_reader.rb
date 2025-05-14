require 'nokogiri'

class HtmlReader
  def read(path)
    htmlLine = ""
    imageEntries = []
    File.foreach(path) { |line|
      artworkLine = false
      Nokogiri::HTML.parse(line).css('span').each do |span|
        if(span.text.strip == 'Artworks')
          artworkLine = true
        end
      end

      if(artworkLine) 
        parsedLine = Nokogiri::HTML.parse(line).css('div div a').map {|line| 
          if(line['href'] =~ /\/search/)
            puts line
            puts ""
          end
        }
      end
    }
  end
end

reader = HtmlReader.new.read('files\van-gogh-paintings.html')
