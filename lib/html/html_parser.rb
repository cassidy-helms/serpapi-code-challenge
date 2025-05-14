require_relative 'search_result_types/artwork'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks'
  end

  def self.parse(line)
    parseType = nil
    Nokogiri::HTML.parse(line).css('span').each do |span|
      if(span.text.strip == Artwork.heading)
        parseType = ParseTypes::ARTWORKS
      end
    end

    if(parseType == ParseTypes::ARTWORKS) 
      parsedLine = Nokogiri::HTML.parse(line).css('div div a').map {|line| 
        if(line['href'] =~ /\/search/)
          puts line
          puts ""
        end
      }
    end
  end
end