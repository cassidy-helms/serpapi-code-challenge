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
      next unless type_map[parse_type]

      type_map[parse_type]&.concat(parse_media(span))
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
  # This method locates the parent div (with a jsname attribute) for the given span,
  # then extracts all valid media items (artworks, books, or albums) from <a> tags within that div.
  # If an image_id is present, it attempts to update the image URL from a corresponding script tag.
  #
  # @param span [Nokogiri::XML::Element] the span element indicating the media section
  # @return [Array<Media>] the parsed media items for this section
  def self.parse_media(span)
    parent_div = find_media_parent(span)
    return [] unless parent_div

    items = parent_div.css('a').filter_map { |a_tag| build_media_from_a_tag(a_tag) }
    retrieve_image_ids(parent_div, items)
  end
  private_class_method :parse_media


  # Builds a Media object from an <a> tag if it contains valid media information.
  #
  # Extracts the name, extensions, image, and image_id from the <a> tag's child elements.
  # Only returns a Media object if the <a> tag has a valid href, name, and image.
  #
  # @param a_tag [Nokogiri::XML::Element] the <a> tag containing media info
  # @return [Media, nil] the constructed Media object, or nil if required fields are missing
  def self.build_media_from_a_tag(a_tag)
    return unless is_search_link?(a_tag)

    name, extensions = extract_name_and_extensions(a_tag)
    image_tag = a_tag.at_css('img')
    image, image_id = extract_image_info(image_tag)

    return unless [a_tag['href'], name, image].all? { |v| v.to_s.strip != '' }
    Media.new(name, extensions, "https://www.google.com#{a_tag['href']}", image, image_id)
  end
  private_class_method :build_media_from_a_tag

  # Checks if the given <a> tag is for a search
  #
  # @param a_tag [Nokogiri::XML::Element] the <a> tag to check
  # @return [Boolean] true if the link is valid, false otherwise
  def self.is_search_link?(a_tag)
    a_tag['href'] =~ %r{/search}
  end
  private_class_method :is_search_link?

  # Extracts the name and extensions from an <a> tag's child <div> elements.
  #
  # The first non-blank <div> is ignored, the second is used as the name,
  # and any subsequent non-blank <div>s are collected as extensions.
  #
  # @param a_tag [Nokogiri::XML::Element] the <a> tag containing media info
  # @return [Array] an array with the name (String or nil) and extensions (Array of Strings)
  def self.extract_name_and_extensions(a_tag)
    div_texts = a_tag.css('div').map { |div| div.text.strip }.reject(&:empty?)
    name = div_texts[1]
    extensions = div_texts[2..].to_a.reject { |ext| ext.strip.empty? }
    [name, extensions]
  end
  private_class_method :extract_name_and_extensions

  # Extracts the image URL and image ID from an <img> tag.
  #
  # Prefers the 'data-src' attribute for the image URL, falling back to 'src' if not present.
  # Returns nil values if the image tag is missing.
  #
  # @param image_tag [Nokogiri::XML::Element, nil] the <img> tag to extract info from
  # @return [Array] an array with the image URL (String or nil) and image ID (String or nil)
  def self.extract_image_info(image_tag)
    return [nil, nil] unless image_tag
    image = image_tag['data-src'] || image_tag['src']
    image_id = image_tag['id']
    [image, image_id]
  end
  private_class_method :extract_image_info

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
