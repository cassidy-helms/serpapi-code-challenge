require_relative 'search_result_types/artwork'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks'
  end

  def self.parse(html)
    results = SearchResults.new
    parse_type = determineParseType(html)

    if(parse_type == ParseTypes::ARTWORKS)
      results.artworks.concat(parseArtworks(html))
    end

    results
  end

  def self.determineParseType(html)
    Nokogiri::HTML.parse(html).css('span').each do |span|
      if(span.text.strip == Artwork.heading)
        return parse_type = ParseTypes::ARTWORKS
      end
    end
  end
  :private

  def self.parseArtworks(html)
      artworks = []
      Nokogiri::HTML.parse(html).css('div div a').each {|a_tag| 
        if(a_tag['href'] =~ /\/search/)
          link = a_tag['href']

          div_texts = a_tag.css('div').map { |div| div.text.strip }
          name = div_texts[1]
          extensions = div_texts[2..] || []

          image_tag = a_tag.at_css('img')
          image_src = image_tag['src'] if image_tag
          image_data_src = image_tag['data-src'] if image_tag
          image = image_data_src || image_src
          image_id = image_tag['id'] if image_tag

          all_extensions_present = extensions.all? { |ext| ext.to_s.strip != "" }
          if !extensions.empty? && all_extensions_present && [link, name, image].all? { |v| v.to_s.strip != "" }            
            artworks << Artwork.new(name, extensions, "https://www.google.com#{link}", image, image_id)
          end
        end
      }

      artworks.each {|artwork|
        if(artwork.image_id)
          doc = Nokogiri::HTML.parse(html).xpath("//script[contains(text(), '#{artwork.image_id}')]")
          image_src = extract_source_variable_from_javascript_string(doc.text)
          
          artwork.image = image_src if image_src
        end
      }

      return artworks
  end
  :private

  def self.extract_source_variable_from_javascript_string(js_string)
    if js_string =~ /var\s+s\s*=\s*'([^']+)'/
      return $1
    end
    nil
  end
  :private
end