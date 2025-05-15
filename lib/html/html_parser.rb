require_relative 'search_result_types/artwork'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks'
  end

  def self.parse(line)
    parse_type = determineParseType(line)

    if(parse_type == ParseTypes::ARTWORKS)
      artworks = parseArtworks(line)
      # artworks.each { |artwork|
      #   puts "#{artwork.name}, #{artwork.year}, #{artwork.link}"
      # }
      return artworks
    end
  end

  def self.determineParseType(line)
    Nokogiri::HTML.parse(line).css('span').each do |span|
      if(span.text.strip == Artwork.heading)
        return parse_type = ParseTypes::ARTWORKS
      end
    end
  end
  :private

  def self.parseArtworks(line)
      artworks = []
      Nokogiri::HTML.parse(line).css('div div a').each {|a_tag| 
        if(a_tag['href'] =~ /\/search/)
          link = a_tag['href']

          div_texts = a_tag.css('div').map { |div| div.text.strip }
          name = div_texts[1]
          year = div_texts[2]

          if [link, name, year].all? { |v| v.to_s.strip != "" }            
            artworks << Artwork.new(name, year, "https://www.google.com#{link}")
          end
        end
      }
      return artworks
  end
end