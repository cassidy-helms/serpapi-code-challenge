# frozen_string_literal: true

require_relative 'search_result_types/artwork'
require_relative 'search_result_types/book'
require_relative 'search_result_types/album'
require_relative 'search_result_types/media'

# HtmlParser parses HTML content and extracts structured search results
# for various media types
#
# Usage:
#   results = HtmlParser.parse(html_string)
class HtmlParser
  module ParseTypes
    ARTWORKS = ['Artworks',
                BOOKS = 'Books',
                ALBUMS = 'Albums'].freeze
  end

  # Parses the given HTML and returns a SearchResults object.
  #
  # @param html [String] the HTML content to parse
  # @return [SearchResults] the parsed search results
  def self.parse(html)
    results = SearchResults.new

    type_map = {
      ParseTypes::ARTWORKS => results.artworks,
      ParseTypes::BOOKS => results.books,
      ParseTypes::ALBUMS => results.albums
    }

    Nokogiri::HTML.parse(html).css('span').each do |span|
      parse_type = determine_parse_type(span)
      next if parse_type.nil?

      items = parse_media(span)
      type_map[parse_type]&.concat(items)
    end

    results
  end

  # Determines the parse type for a given span element.
  #
  # @param span [Nokogiri::XML::Element] the span element
  # @return [String, nil] the parse type or nil if not recognized
  def self.determine_parse_type(span)
    return ParseTypes::ARTWORKS if span.text.strip == Artwork.heading
    return ParseTypes::BOOKS if span.text.strip == Book.heading
    return ParseTypes::ALBUMS if span.text.strip == Album.heading

    nil
  end
  private_class_method :determine_parse_type

  # Parses media items for the given span.
  #
  # @param span [Nokogiri::XML::Element] the span element
  # @return [Array<Media>] the parsed media items
  def self.parse_media(span)
    parent_div = find_media_parent(span)
    items = []

    parent_div.css('a').each do |a_tag|
      next unless a_tag['href'] =~ %r{/search}

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

      if [link, name, image].all? { |v| v.to_s.strip != '' }
        items << Media.new(name, extensions, "https://www.google.com#{link}", image, image_id)
      end
    end

    retrieve_image_ids(parent_div, items)
  end
  private_class_method :parse_media

  # Finds the parent div with a jsname attribute for the given span.  This div indicates where the actual media items will be located in the html file
  #
  # @param span [Nokogiri::XML::Element] the span element
  # @return [Nokogiri::XML::Element, nil] the parent div or nil
  def self.find_media_parent(span)
    section_div = span
    section_div = section_div.parent while section_div && (!section_div.name.eql?('div') || !section_div['jsname'])
    section_div
  end
  private_class_method :find_media_parent

  # Updates image paths for items if the img contained an id
  # Img tags with an id have a thumbnail path in a corresponding script tag further down the html file
  #
  # @param html [Nokogiri::XML::Element] the HTML section to search for scripts
  # @param items [Array<Media>] the media items to update
  # @return [Array<Media>] the updated media items
  def self.retrieve_image_ids(html, items)
    items.each do |item|
      next unless item.image_id

      script = html.xpath("//script[contains(text(), '#{item.image_id}')]")
      image_src = extract_source_variable_from_javascript_string(script.text)
      item.image = image_src if image_src
    end
    items
  end
  private_class_method :retrieve_image_ids

  # Extracts the image source variable from a JavaScript string. Also decodes unicode in the string.
  #
  # @param js_string [String] the JavaScript string
  # @return [String, nil] the extracted image source or nil
  def self.extract_source_variable_from_javascript_string(js_string)
    if js_string =~ /var\s+s\s*=\s*'([^']+)'/
      value = ::Regexp.last_match(1)
      value = value.gsub(/\\x([0-9A-Fa-f]{2})/) { [::Regexp.last_match(1)].pack('H2') }
      return value
    end
    nil
  end
  private_class_method :extract_source_variable_from_javascript_string
end
