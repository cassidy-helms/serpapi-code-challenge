require_relative 'search_result_types/artwork'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks'
  end

  def self.parse(line)
    parseType = determineParseType(line)

    if(parseType == ParseTypes::ARTWORKS)
      artworks = []
      parsedLine = Nokogiri::HTML.parse(line).css('div div a').each {|line| 
        if(line['href'] =~ /\/search/)
          link = line['href']

          name = line.css('div')[1]&.text&.strip
          puts name
          year = line.css('div')[2]&.text&.strip
          puts year

        if [link, name, year].all? { |v| v.to_s.strip != "" }            
            artworks << Artwork.new(name, year, link)
          end
        end
      }

      artworks.each { |artwork|
        puts "#{artwork.name}, #{artwork.year}, #{artwork.link}"
      }
    end
  end

  def self.determineParseType(line)
    Nokogiri::HTML.parse(line).css('span').each do |span|
      if(span.text.strip == Artwork.heading)
        return parseType = ParseTypes::ARTWORKS
      end
    end
  end
  :private
end