require_relative 'search_result_types/artwork'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks'
  end

  def self.parse(line)
    results = SearchResults.new
    parse_type = determineParseType(line)

    if(parse_type == ParseTypes::ARTWORKS)
      results.artworks.concat(parseArtworks(line))
    end

    results
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
          extensions = [div_texts[2]]

          image_tag = a_tag.at_css('img')
          image_src = image_tag['src'] if image_tag
          image_data_src = image_tag['data-src'] if image_tag
          image = image_data_src || image_src

          if !extensions.empty? && [link, name, extensions[0], image].all? { |v| v.to_s.strip != "" }            
            artworks << Artwork.new(name, extensions, "https://www.google.com#{link}", image)
          end
        end
      }
      return artworks
  end
  :private
end