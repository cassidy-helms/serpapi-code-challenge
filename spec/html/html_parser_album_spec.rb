# frozen_string_literal: true

require 'nokogiri'
require_relative '../../lib/html/html_parser'
require_relative '../../lib/html/search_result_types/search_results'

RSpec.shared_examples 'returns empty albums search results' do
  it 'returns empty albums search results' do
    results = HtmlParser.parse(album_html)
    expect(results.albums).to eq([])
  end
end

RSpec.describe HtmlParser do
  describe '.parse' do
    context 'html contains search results' do
      context 'html contains img src' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Albums</span>
            </div>
            <div>
              <div>
                <a href="/search?client=firefox-b-1-d&amp;sca_esv=7ce7144faa458147&amp;sxsrf=AHTn8zoCSHweW1_RiYR3JoPiH5sExdDdYg:1747425507859&amp;q=The+Rolling+Stones+Sticky+Fingers&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MM8tK1DiArEMM3IrjSu0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7EqhmSkKgTl5-Rk5qUrBJfk56UWA6nM5OxKBTegUGpRMQDofcRCVQAAAA&amp;sa=X&amp;ved=2ahUKEwjSiKul46iNAxWjEFkFHVdrMl0Q9OUBegQITBAD">
                  <wp-grid-tile class="JJw92">
                    <div jsname="QRMGrb" class="olSdv">
                      <img jsname="nWzOlc" class="d7ENZc" alt="" data-h="90" data-w="90" id="_45gnaJKLNKOh5NoP19bJ6QU_90" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                    </div>
                    <div class="TT9RUc uV10if">
                      <div class="JjtOHd">Sticky Fingers</div>
                      <div class="ellip yF4Rkc AqEFvb">1971</div>
                    </div>
                  </wp-grid-tile>
                </a>
              </div>
            </div>
            <script nonce="CxPhAa7IIoPl8fTeJtLezg">(function(){var id='z9PoV';document.getElementById(id).setAttribute("lta",Date.now());})();</script><script nonce="CxPhAa7IIoPl8fTeJtLezg">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3//Z';var ii=['_45gnaJKLNKOh5NoP19bJ6QU_90'];_setImagesSrc(ii,s);})();</script>            </div>
          HTML
        end

        it 'returns a SearchResults object' do
          results = HtmlParser.parse(album_html)
          expect(results).to be_a(SearchResults)
        end

        it 'parses albums into results.albums' do
          results = HtmlParser.parse(album_html)
          expect(results.albums.length).to eq(1)
          album = results.albums.first
          expect(album.name).to eq('Sticky Fingers')
          expect(album.extensions).to include('1971')
          expect(album.link).to eq('https://www.google.com/search?client=firefox-b-1-d&sca_esv=7ce7144faa458147&sxsrf=AHTn8zoCSHweW1_RiYR3JoPiH5sExdDdYg:1747425507859&q=The+Rolling+Stones+Sticky+Fingers&stick=H4sIAAAAAAAAAONgFuLQz9U3MM8tK1DiArEMM3IrjSu0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7EqhmSkKgTl5-Rk5qUrBJfk56UWA6nM5OxKBTegUGpRMQDofcRCVQAAAA&sa=X&ved=2ahUKEwjSiKul46iNAxWjEFkFHVdrMl0Q9OUBegQITBAD')
          expect(album.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3//Z')
          expect(album.image_id).to eq('_45gnaJKLNKOh5NoP19bJ6QU_90')
        end
      end

      context 'html contains img data-src' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Albums</span>
            </div>
            <div>
              <div>
                <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=Sticky+Fingers&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                  <img class="taFZJe" alt="Sticky Fingers" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                  <div class="KHK6lb">
                    <div class="pgNMRc">Sticky Fingers</div>
                    <div class="cxzHyb">1971</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it 'returns a SearchResults object' do
          results = HtmlParser.parse(album_html)
          expect(results).to be_a(SearchResults)
        end

        it 'parses albums into results.albums' do
          results = HtmlParser.parse(album_html)
          expect(results.albums.length).to eq(1)
          album = results.albums.first
          expect(album.name).to eq('Sticky Fingers')
          expect(album.extensions).to include('1971')
          expect(album.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Sticky+Fingers&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
          expect(album.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
          expect(album.image_id).to eq(nil)
        end
      end

      context 'contains no extensions' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Albums</span>
            </div>
            <div>
              <div>
                <a href="/search?test">
                  <img id="imgid3" src="data:image/png;base64,AAA" />
                  <div>
                    <div>Album With No Extensions</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it 'parses album with an empty extensions array' do
          results = HtmlParser.parse(album_html)
          album = results.albums.first
          expect(album.extensions).to eq([])
        end
      end

      context 'contains multiple extensions' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Albums</span>
            </div>
            <div>
              <div>
                <a href="/search?test">
                  <img id="imgid2" src="data:image/png;base64,AAA" />
                  <div>
                    <div>Album With Two Extensions</div>
                    <div>Medium</div>
                    <div>Year</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it 'parses both extensions into the extensions array' do
          results = HtmlParser.parse(album_html)
          album = results.albums.first
          expect(album.extensions.size).to eq(2)
          expect(album.extensions).to eq(%w[Medium Year])
        end
      end

      context 'search results can contain multiple albums' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Albums</span>
            </div>
            <div>
              <div>
                <a href="/search?client=firefox-b-1-d&amp;sca_esv=7ce7144faa458147&amp;sxsrf=AHTn8zoCSHweW1_RiYR3JoPiH5sExdDdYg:1747425507859&amp;q=The+Rolling+Stones+Sticky+Fingers&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MM8tK1DiArEMM3IrjSu0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7EqhmSkKgTl5-Rk5qUrBJfk56UWA6nM5OxKBTegUGpRMQDofcRCVQAAAA&amp;sa=X&amp;ved=2ahUKEwjSiKul46iNAxWjEFkFHVdrMl0Q9OUBegQITBAD">
                  <wp-grid-tile class="JJw92">
                    <div jsname="QRMGrb" class="olSdv">
                      <img jsname="nWzOlc" class="d7ENZc" alt="" data-h="90" data-w="90" id="_45gnaJKLNKOh5NoP19bJ6QU_90" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                    </div>
                    <div class="TT9RUc uV10if">
                      <div class="JjtOHd">Sticky Fingers</div>
                      <div class="ellip yF4Rkc AqEFvb">1971</div>
                    </div>
                  </wp-grid-tile>
                </a>
              </div>
              <div>
                <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=Hackney+Diamonds&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                  <img class="taFZJe" alt="Hackney Diamonds" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                  <div class="KHK6lb">
                    <div class="pgNMRc">Hackney Diamonds</div>
                    <div class="cxzHyb">2023</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_45gnaJKLNKOh5NoP19bJ6QU_90'];var r='';_setImagesSrc(ii,s,r);})();</script>
          HTML
        end

        it 'returns a SearchResults object' do
          results = HtmlParser.parse(album_html)
          expect(results).to be_a(SearchResults)
        end

        it 'parses albums into results.albums' do
          results = HtmlParser.parse(album_html)
          expect(results.albums.length).to eq(2)
        end

        it 'parses img src albums with script src' do
          results = HtmlParser.parse(album_html)
          album = results.albums.first
          expect(album.name).to eq('Sticky Fingers')
          expect(album.extensions).to include('1971')
          expect(album.link).to eq('https://www.google.com/search?client=firefox-b-1-d&sca_esv=7ce7144faa458147&sxsrf=AHTn8zoCSHweW1_RiYR3JoPiH5sExdDdYg:1747425507859&q=The+Rolling+Stones+Sticky+Fingers&stick=H4sIAAAAAAAAAONgFuLQz9U3MM8tK1DiArEMM3IrjSu0xLOTrfRzS4szk_UTi0oyi0usEnOSSnOLF7EqhmSkKgTl5-Rk5qUrBJfk56UWA6nM5OxKBTegUGpRMQDofcRCVQAAAA&sa=X&ved=2ahUKEwjSiKul46iNAxWjEFkFHVdrMl0Q9OUBegQITBAD')
          expect(album.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=')
          expect(album.image_id).to eq('_45gnaJKLNKOh5NoP19bJ6QU_90')
        end

        it 'parses img data-src albums' do
          results = HtmlParser.parse(album_html)
          album = results.albums[1]
          expect(album.name).to eq('Hackney Diamonds')
          expect(album.extensions).to include('2023')
          expect(album.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Hackney+Diamonds&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
          expect(album.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
          expect(album.image_id).to eq(nil)
        end
      end
    end


    context 'html does not contain search results' do
      context 'album missing required fields' do
        context 'missing href' do
          let(:album_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Albums</span>
              </div>
              <div>
                <div>
                  <a>
                    <img id="albumimg" src="data:image/png;base64,ALBUM" />
                    <div></div>
                    <div>Album Title</div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it_behaves_like 'returns empty albums search results'
        end

        context 'missing img tag' do
          let(:album_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Albums</span>
              </div>
              <div>
                <div>
                  <a href="/search?album">
                    <div></div>
                    <div>Album Title</div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it_behaves_like 'returns empty albums search results'
        end

        context 'missing name' do
          let(:album_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Albums</span>
              </div>
              <div>
                <div>
                  <a href="/search?album">
                    <img id="albumimg" src="data:image/png;base64,ALBUM" />
                    <div></div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it_behaves_like 'returns empty albums search results'
        end


        context 'if not a album page' do
          let(:album_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Maps</span>
              </div>
              <div>
                <div>
                  <a href="/search?test">
                    <img id="imgid" src="data:image/png;base64,AAA" />
                    <div>
                      <div>Albums</div>
                    </div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it_behaves_like 'returns empty albums search results'
        end
      end

      context 'if not a search result' do
        let(:album_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Maps</span>
            </div>
            <div>
              <div>
                <a href="/notsearch">
                  <img id="imgid2" src="data:image/png;base64,AAA" />
                  <div>
                    <div>Album</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it_behaves_like 'returns empty albums search results'
      end

      context 'if html is empty' do
        let(:album_html) { '' }

        it_behaves_like 'returns empty albums search results'
      end
    end
  end
end
