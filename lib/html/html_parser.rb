require_relative 'search_result_types/artwork'
require_relative 'search_result_types/book'
require_relative 'search_result_types/media'

class HtmlParser
  module ParseTypes
    ARTWORKS = 'Artworks',
    BOOKS = 'Books'
  end

  def self.parse(html)
    results = SearchResults.new

    Nokogiri::HTML.parse(html).css('span').each do |span|
      parse_type = determine_parse_type(span)
      next if parse_type.nil?

      items = parse_media(span)

      if(parse_type == ParseTypes::ARTWORKS)
        results.artworks.concat(items)
      elsif(parse_type == ParseTypes::BOOKS)
        results.books.concat(items)
      end
    end

    results
  end

  def self.determine_parse_type(span)
    return ParseTypes::ARTWORKS if span.text.strip == Artwork.heading
    return ParseTypes::BOOKS if span.text.strip == Book.heading

    nil
  end
  private_class_method :determine_parse_type

  def self.parse_media(span)
    parent_div = find_media_parent(span)

    items = []
    parent_div.css('a').each {|a_tag| 
      next unless a_tag['href'] =~ /\/search/

      link = a_tag['href']
      div_texts = a_tag.css('div').map { |div| div.text.strip }
      non_blank_divs = div_texts.reject(&:empty?)

      name = non_blank_divs[1]
      extensions = non_blank_divs[2..].to_a.reject { |ext| ext.strip.empty? }

      image_tag = a_tag.at_css('img')
      image_src = image_tag['src'] if image_tag
      image_data_src = image_tag['data-src'] if image_tag
      image = image_data_src || image_src
      image_id = image_tag['id'] if image_tag
  
      if [link, name, image].all? { |v| v.to_s.strip != "" }            
        items << Media.new(name, extensions, "https://www.google.com#{link}", image, image_id)
      end
    }

    retrieve_image_ids(parent_div, items)
  end
  private_class_method :parse_media

  def self.find_media_parent(span)
    section_div = span
    while section_div && (!section_div.name.eql?('div') || !section_div['jsname'])
      section_div = section_div.parent
    end
    section_div
  end
  private_class_method :find_media_parent

  def self.retrieve_image_ids(html, items) 
    items.each {|item|
      if item.image_id
        doc = html.xpath("//script[contains(text(), '#{item.image_id}')]")
        image_src = extract_source_variable_from_javascript_string(doc.text)
        
        item.image = image_src if image_src
      end
    }

    items
  end
  private_class_method :retrieve_image_ids

  def self.extract_source_variable_from_javascript_string(js_string)
    if js_string =~ /var\s+s\s*=\s*'([^']+)'/
      value = $1
      value = value.gsub(/\\x([0-9A-Fa-f]{2})/) { [$1].pack("H2") }
      return value
    end
    nil
  end
  private_class_method :extract_source_variable_from_javascript_string
end