require 'nokogiri'
require_relative '../../lib/html/html_parser'
require_relative '../../lib/html/search_result_types/artwork'
require_relative '../../lib/html/search_result_types/search_results'

RSpec.describe HtmlParser do
  describe ".parse" do
    context "html contains search results" do
      context "artwork contains img src" do
        let(:artwork_html) do
          <<-HTML
          <span>Artworks</span>
          <div>
            <div>
              <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=The+Starry+Night&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD">
                <img class="taFZJe" alt="The Starry Night" id="_L_FkZ4qlAtyDwbkP49Pj0QU_63" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                <div class="KHK6lb">
                  <div class="pgNMRc">The Starry Night</div>
                  <div class="cxzHyb">1889</div>
                </div>
              </a>
            </div>
          </div>
          <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_L_FkZ4qlAtyDwbkP49Pj0QU_63'];var r='';_setImagesSrc(ii,s,r);})();</script>
          HTML
        end

        it "returns a SearchResults object" do
          results = HtmlParser.parse(artwork_html)
          expect(results).to be_a(SearchResults)
        end

        it "parses artworks into results.artworks" do
          results = HtmlParser.parse(artwork_html)
          expect(results.artworks.length).to eq(1)
          artwork = results.artworks.first
          expect(artwork.name).to eq("The Starry Night")
          expect(artwork.extensions).to include("1889")
          expect(artwork.link).to eq("https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD")
          expect(artwork.image).to eq("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=")
          expect(artwork.image_id).to eq("_L_FkZ4qlAtyDwbkP49Pj0QU_63")
        end
      end

      context "artwork contains img data-src" do
        let(:artwork_html) do
          <<-HTML
          <span>Artworks</span>
          <div>
            <div>
              <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=Bedroom+in+Arles&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                <img class="taFZJe" alt="Bedroom in Arles" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                <div class="KHK6lb">
                  <div class="pgNMRc">Bedroom in Arles</div>
                  <div class="cxzHyb">1888</div>
                </div>
              </a>
            </div>
          </div>
          HTML
        end

        it "returns a SearchResults object" do
          results = HtmlParser.parse(artwork_html)
          expect(results).to be_a(SearchResults)
        end

        it "parses artworks into results.artworks" do
          results = HtmlParser.parse(artwork_html)
          expect(results.artworks.length).to eq(1)
          artwork = results.artworks.first
          expect(artwork.name).to eq("Bedroom in Arles")
          expect(artwork.extensions).to include("1888")
          expect(artwork.link).to eq("https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Bedroom+in+Arles&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV")
          expect(artwork.image).to eq("https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3")
          expect(artwork.image_id).to eq(nil)
        end
      end

      context "artwork contains no extensions" do
        let(:artwork_html) do
          <<-HTML
          <span>Artworks</span>
          <div>
            <div>
              <a href="/search?test=3">
                <img id="imgid3" src="data:image/png;base64,AAA" />
                <div></div>
                <div>Artwork With No Extensions</div>
              </a>
            </div>
          </div>
          HTML
        end

        it "parses artwork with an empty extensions array" do
          results = HtmlParser.parse(artwork_html)
          artwork = results.artworks.first
          expect(artwork.extensions).to eq([])
        end
      end

      context "artwork contains multiple extensions" do
        let(:artwork_html) do
          <<-HTML
          <span>Artworks</span>
          <div>
            <div>
              <a href="/search?test=2">
                <img id="imgid2" src="data:image/png;base64,AAA" />
                <div></div>
                <div>Artwork With Two Extensions</div>
                <div>Medium</div>
                <div>Year</div>
              </a>
            </div>
          </div>
          HTML
        end

        it "parses both extensions into the extensions array" do
          results = HtmlParser.parse(artwork_html)
          artwork = results.artworks.first
          expect(artwork.extensions.size).to eq(2)
          expect(artwork.extensions).to eq(["Medium", "Year"])
        end
      end

      context "search results can contain multiple artworks" do
        let(:artwork_html) do
          <<-HTML
          <span>Artworks</span>
          <div>
            <div>
              <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=The+Starry+Night&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD">
                <img class="taFZJe" alt="The Starry Night" id="_L_FkZ4qlAtyDwbkP49Pj0QU_63" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                <div class="KHK6lb">
                  <div class="pgNMRc">The Starry Night</div>
                  <div class="cxzHyb">1889</div>
                </div>
              </a>
            </div>
            <div>
              <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=Bedroom+in+Arles&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                <img class="taFZJe" alt="Bedroom in Arles" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                <div class="KHK6lb">
                  <div class="pgNMRc">Bedroom in Arles</div>
                  <div class="cxzHyb">1888</div>
                </div>
              </a>
            </div>
          </div>
          <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_L_FkZ4qlAtyDwbkP49Pj0QU_63'];var r='';_setImagesSrc(ii,s,r);})();</script>
          HTML
        end

        it "returns a SearchResults object" do
          results = HtmlParser.parse(artwork_html)
          expect(results).to be_a(SearchResults)
        end

        it "parses artworks into results.artworks" do
          results = HtmlParser.parse(artwork_html)
          expect(results.artworks.length).to eq(2)
        end

        it "parses img src artworks with script src" do
          results = HtmlParser.parse(artwork_html)
          artwork = results.artworks.first
          expect(artwork.name).to eq("The Starry Night")
          expect(artwork.extensions).to include("1889")
          expect(artwork.link).to eq("https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD")
          expect(artwork.image).to eq("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=")
          expect(artwork.image_id).to eq("_L_FkZ4qlAtyDwbkP49Pj0QU_63")
        end

        it "parses img data-src artworks" do
          results = HtmlParser.parse(artwork_html)

          artwork = results.artworks[1]
          expect(artwork.name).to eq("Bedroom in Arles")
          expect(artwork.extensions).to include("1888")
          expect(artwork.link).to eq("https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Bedroom+in+Arles&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV")
          expect(artwork.image).to eq("https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3")
          expect(artwork.image_id).to eq(nil)
        end
      end
    end

    it "returns empty artworks if not an artwork page" do
      html = "<span>Maps</span>"
      results = HtmlParser.parse(html)
      expect(results.artworks).to eq([])
    end
  end
end