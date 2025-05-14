class HtmlParser
  def self.parse(line)
      parseType = false
      Nokogiri::HTML.parse(line).css('span').each do |span|
        if(span.text.strip == 'Artworks')
          parseType = 'Artworks'
        end
      end

      if(parseType == 'Artworks') 
        parsedLine = Nokogiri::HTML.parse(line).css('div div a').map {|line| 
          if(line['href'] =~ /\/search/)
            puts line
            puts ""
          end
        }
      end
  end
end