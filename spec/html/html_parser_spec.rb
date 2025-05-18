# frozen_string_literal: true

require 'nokogiri'
require_relative '../../lib/html/html_parser'
require_relative '../../lib/html/search_result_types/artwork'
require_relative '../../lib/html/search_result_types/search_results'

RSpec.describe HtmlParser do
  RSpec.shared_examples 'returns empty artworks search results' do
    it 'returns empty artworks search results' do
      results = HtmlParser.parse(artwork_html)
      expect(results.artworks).to eq([])
    end
  end

  RSpec.shared_examples 'returns empty books search results' do
    it 'returns empty books search results' do
      results = HtmlParser.parse(book_html)
      expect(results.books).to eq([])
    end
  end

  RSpec.shared_examples 'returns empty albums search results' do
    it 'returns albums books search results' do
      results = HtmlParser.parse(album_html)
      expect(results.albums).to eq([])
    end
  end

  describe '.parse' do
    context 'html contains search results' do
      context 'media type artwork' do
        context 'contains img src' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Artworks</span>
              </div>
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
            </div>
            <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_L_FkZ4qlAtyDwbkP49Pj0QU_63'];var r='';_setImagesSrc(ii,s,r);})();</script>
            HTML
          end

          it 'returns a SearchResults object' do
            results = HtmlParser.parse(artwork_html)
            expect(results).to be_a(SearchResults)
          end

          it 'parses artworks into results.artworks' do
            results = HtmlParser.parse(artwork_html)
            expect(results.artworks.length).to eq(1)
            artwork = results.artworks.first
            expect(artwork.name).to eq('The Starry Night')
            expect(artwork.extensions).to include('1889')
            expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD')
            expect(artwork.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=')
            expect(artwork.image_id).to eq('_L_FkZ4qlAtyDwbkP49Pj0QU_63')
          end
        end

        context 'contains img data-src' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Artworks</span>
              </div>
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
            </div>
            HTML
          end

          it 'returns a SearchResults object' do
            results = HtmlParser.parse(artwork_html)
            expect(results).to be_a(SearchResults)
          end

          it 'parses artworks into results.artworks' do
            results = HtmlParser.parse(artwork_html)
            expect(results.artworks.length).to eq(1)
            artwork = results.artworks.first
            expect(artwork.name).to eq('Bedroom in Arles')
            expect(artwork.extensions).to include('1888')
            expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Bedroom+in+Arles&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
            expect(artwork.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
            expect(artwork.image_id).to eq(nil)
          end
        end

        context 'contains no extensions' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Artworks</span>
              </div>
              <div>
                <div>
                  <a href="/search?test">
                    <img id="imgid3" src="data:image/png;base64,AAA" />
                    <div>
                      <div>Artwork With No Extensions</div>
                    </div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it 'parses artwork with an empty extensions array' do
            results = HtmlParser.parse(artwork_html)
            artwork = results.artworks.first
            expect(artwork.extensions).to eq([])
          end
        end

        context 'contains multiple extensions' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Artworks</span>
              </div>
              <div>
                <div>
                  <a href="/search?test">
                    <img id="imgid2" src="data:image/png;base64,AAA" />
                    <div>
                      <div>Artwork With Two Extensions</div>
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
            results = HtmlParser.parse(artwork_html)
            artwork = results.artworks.first
            expect(artwork.extensions.size).to eq(2)
            expect(artwork.extensions).to eq(%w[Medium Year])
          end
        end

        context 'search results can contain multiple artworks' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Artworks</span>
              </div>
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
            </div>
            <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_L_FkZ4qlAtyDwbkP49Pj0QU_63'];var r='';_setImagesSrc(ii,s,r);})();</script>
            HTML
          end

          it 'returns a SearchResults object' do
            results = HtmlParser.parse(artwork_html)
            expect(results).to be_a(SearchResults)
          end

          it 'parses artworks into results.artworks' do
            results = HtmlParser.parse(artwork_html)
            expect(results.artworks.length).to eq(2)
          end

          it 'parses img src artworks with script src' do
            results = HtmlParser.parse(artwork_html)
            artwork = results.artworks.first
            expect(artwork.name).to eq('The Starry Night')
            expect(artwork.extensions).to include('1889')
            expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD')
            expect(artwork.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=')
            expect(artwork.image_id).to eq('_L_FkZ4qlAtyDwbkP49Pj0QU_63')
          end

          it 'parses img data-src artworks' do
            results = HtmlParser.parse(artwork_html)

            artwork = results.artworks[1]
            expect(artwork.name).to eq('Bedroom in Arles')
            expect(artwork.extensions).to include('1888')
            expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=Bedroom+in+Arles&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
            expect(artwork.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
            expect(artwork.image_id).to eq(nil)
          end
        end
      end

      context 'media type books' do
        context 'html contains book search results' do
          let(:book_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Books</span>
              </div>
              <div>
                <div>
                  <a href="/search?client=firefox-b-1-d&amp;sca_esv=7ce7144faa458147&amp;sxsrf=AHTn8zoEwNBGiIfsFDahq3jpdoxu1s8jbg:1747418641283&amp;q=The+Shining+(novel)&amp;stick=H4sIAAAAAAAAAONgFuLSz9U3yCqxNEgzVeIAsc2Ty4q0pLKTrfST8vOz9RNLSzLyi6xA7GKF_LycykWswiEZqQrBGZl5mXnpChp5-WWpOZoAO7LiS0oAAAA&amp;sa=X&amp;ved=2ahUKEwidyYzbyaiNAxWmEFkFHZFFM3sQ9OUBegQIUBAF">
                    <wp-grid-tile class="JJw92">
                      <div jsname="QRMGrb" class="olSdv">
                        <img jsname="nWzOlc" class="d7ENZc" alt="" data-h="149" data-w="90" id="_EX4naN38EKah5NoPkYvN2Qc_89" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                      </div>
                      <div class="TT9RUc uV10if">
                        <div class="JjtOHd">The Shining</div>
                        <div class="ellip yF4Rkc AqEFvb">1977</div>
                      </div>
                    </wp-grid-tile>
                  </a>
                </div>
              </div>
            </div>
            <script nonce="D1fOy4rIvhmtRG4ODT-cdg">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys\x3d';var ii=['_EX4naN38EKah5NoPkYvN2Qc_89'];_setImagesSrc(ii,s);})();</script>#{'            '}
            HTML
          end

          it 'returns a SearchResults object' do
            results = HtmlParser.parse(book_html)
            expect(results).to be_a(SearchResults)
          end

          it 'parses books into results.books' do
            results = HtmlParser.parse(book_html)
            expect(results.books.length).to eq(1)
            book = results.books.first
            expect(book.name).to eq('The Shining')
            expect(book.extensions).to include('1977')
            expect(book.link).to eq('https://www.google.com/search?client=firefox-b-1-d&sca_esv=7ce7144faa458147&sxsrf=AHTn8zoEwNBGiIfsFDahq3jpdoxu1s8jbg:1747418641283&q=The+Shining+(novel)&stick=H4sIAAAAAAAAAONgFuLSz9U3yCqxNEgzVeIAsc2Ty4q0pLKTrfST8vOz9RNLSzLyi6xA7GKF_LycykWswiEZqQrBGZl5mXnpChp5-WWpOZoAO7LiS0oAAAA&sa=X&ved=2ahUKEwidyYzbyaiNAxWmEFkFHZFFM3sQ9OUBegQIUBAF')
            expect(book.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys=')
            expect(book.image_id).to eq('_EX4naN38EKah5NoPkYvN2Qc_89')
          end
        end
      end

      context 'media type albums' do
        context 'html contains album search results' do
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

          it 'parses books into results.books' do
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
      end

      context 'multiple media types' do
        let(:html) do
          <<-HTML
          <div jsname="test-artworks">
            <div>
              <span>Artworks</span>
            </div>
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
          </div>
          <div jsname="test-books">
            <div>
              <span>Books</span>
            </div>
            <div>
              <div>
                <a href="/search?client=firefox-b-1-d&amp;sca_esv=7ce7144faa458147&amp;sxsrf=AHTn8zoEwNBGiIfsFDahq3jpdoxu1s8jbg:1747418641283&amp;q=The+Shining+(novel)&amp;stick=H4sIAAAAAAAAAONgFuLSz9U3yCqxNEgzVeIAsc2Ty4q0pLKTrfST8vOz9RNLSzLyi6xA7GKF_LycykWswiEZqQrBGZl5mXnpChp5-WWpOZoAO7LiS0oAAAA&amp;sa=X&amp;ved=2ahUKEwidyYzbyaiNAxWmEFkFHZFFM3sQ9OUBegQIUBAF">
                  <wp-grid-tile class="JJw92">
                    <div jsname="QRMGrb" class="olSdv">
                      <img jsname="nWzOlc" class="d7ENZc" alt="" data-h="149" data-w="90" id="_EX4naN38EKah5NoPkYvN2Qc_89" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" data-deferred="1">
                    </div>
                    <div class="TT9RUc uV10if">
                      <div class="JjtOHd">The Shining</div>
                      <div class="ellip yF4Rkc AqEFvb">1977</div>
                    </div>
                  </wp-grid-tile>
                </a>
              </div>
            </div>
          </div>
          <script nonce="D1fOy4rIvhmtRG4ODT-cdg">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys\x3d';var ii=['_EX4naN38EKah5NoPkYvN2Qc_89'];_setImagesSrc(ii,s);})();</script>#{'            '}
          <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_L_FkZ4qlAtyDwbkP49Pj0QU_63'];var r='';_setImagesSrc(ii,s,r);})();</script>
          HTML
        end

        it 'returns a SearchResults object' do
          results = HtmlParser.parse(html)
          expect(results).to be_a(SearchResults)
        end

        it 'parses artworks into results.artworks' do
          results = HtmlParser.parse(html)
          expect(results.artworks.length).to eq(1)
          artwork = results.artworks.first
          expect(artwork.name).to eq('The Starry Night')
          expect(artwork.extensions).to include('1889')
          expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD')
          expect(artwork.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=')
          expect(artwork.image_id).to eq('_L_FkZ4qlAtyDwbkP49Pj0QU_63')
        end

        it 'parses books into results.books' do
          results = HtmlParser.parse(html)
          expect(results.books.length).to eq(1)
          book = results.books.first
          expect(book.name).to eq('The Shining')
          expect(book.extensions).to include('1977')
          expect(book.link).to eq('https://www.google.com/search?client=firefox-b-1-d&sca_esv=7ce7144faa458147&sxsrf=AHTn8zoEwNBGiIfsFDahq3jpdoxu1s8jbg:1747418641283&q=The+Shining+(novel)&stick=H4sIAAAAAAAAAONgFuLSz9U3yCqxNEgzVeIAsc2Ty4q0pLKTrfST8vOz9RNLSzLyi6xA7GKF_LycykWswiEZqQrBGZl5mXnpChp5-WWpOZoAO7LiS0oAAAA&sa=X&ved=2ahUKEwidyYzbyaiNAxWmEFkFHZFFM3sQ9OUBegQIUBAF')
          expect(book.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys=')
          expect(book.image_id).to eq('_EX4naN38EKah5NoPkYvN2Qc_89')
        end
      end
    end

    context 'html does not contain search results' do
      context 'media type artwork' do
        context 'missing required fields' do
          context 'missing href' do
            let(:artwork_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Artworks</span>
                </div>
                <div>
                  <div>
                    <a>
                      <img id="imgid2" src="data:image/png;base64,AAA" />
                      <div>
                        <div>Artwork</div>
                        <div>Medium</div>
                        <div>Year</div>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty artworks search results'
          end

          context 'missing img tag' do
            let(:artwork_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Artworks</span>
                </div>
                <div>
                  <div>
                    <a href="/search?test">
                      <div>
                        <div>Artwork</div>
                        <div>Medium</div>
                        <div>Year</div>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty artworks search results'
          end

          context 'missing img src or data-src' do
            let(:artwork_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Artworks</span>
                </div>
                <div>
                  <div>
                    <a href="/search?test">
                      <img id="imgid2"/>
                      <div>
                        <div>Artwork</div>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty artworks search results'
          end

          context 'missing name' do
            let(:artwork_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Artworks</span>
                </div>
                <div>
                  <div>
                    <a href="/search?test">
                      <img id="imgid2" src="data:image/png;base64,AAA" />
                      <div></div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty artworks search results'
          end

          # I am assuming the correct answer here is to return the src as the image, but if this was a real scenario, I would check if that is the desired outcome or possibly removing this entry from the returned artworks list
          context 'contains img src but not script' do
            let(:artwork_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Artworks</span>
                </div>
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
              </div>
              HTML
            end

            it 'returns a SearchResults object' do
              results = HtmlParser.parse(artwork_html)
              expect(results).to be_a(SearchResults)
            end

            it 'parses artworks into results.artworks' do
              results = HtmlParser.parse(artwork_html)
              expect(results.artworks.length).to eq(1)
              artwork = results.artworks.first
              expect(artwork.name).to eq('The Starry Night')
              expect(artwork.extensions).to include('1889')
              expect(artwork.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Starry+Night&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiBLFMzC3jC7WUspOt9Msyi0sTc-ITi0qQmJnFJVbl-UXZxYtYBUIyUhWCSxKLiioV_DLTM0oAdKX0-E4AAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAD')
              expect(artwork.image).to eq('data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==')
              expect(artwork.image_id).to eq('_L_FkZ4qlAtyDwbkP49Pj0QU_63')
            end
          end
        end

        context 'if not an artwork page' do
          let(:artwork_html) do
            <<-HTML
            <div jsname="test">
              <div>
                <span>Maps</span>
              </div>
              <div>
                <div>
                  <a href="/search?test">
                    <img id="imgid2" src="data:image/png;base64,AAA" />
                    <div>
                      <div>Artwork</div>
                    </div>
                  </a>
                </div>
              </div>
            </div>
            HTML
          end

          it_behaves_like 'returns empty artworks search results'
        end
      end

      context 'media type book' do
        context 'book missing required fields' do
          context 'missing href' do
            let(:book_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Books</span>
                </div>
                <div>
                  <div>
                    <a>
                      <img id="bookimg" src="data:image/png;base64,BOOK" />
                      <div></div>
                      <div>Book Title</div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty books search results'
          end

          context 'missing img tag' do
            let(:book_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Books</span>
                </div>
                <div>
                  <div>
                    <a href="/search?book">
                      <div></div>
                      <div>Book Title</div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty books search results'
          end

          context 'missing name' do
            let(:book_html) do
              <<-HTML
              <div jsname="test">
                <div>
                  <span>Books</span>
                </div>
                <div>
                  <div>
                    <a href="/search?book=3">
                      <img id="bookimg" src="data:image/png;base64,BOOK" />
                      <div></div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty books search results'
          end


          context 'if not a book page' do
            let(:book_html) do
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
                        <div>Artwork</div>
                      </div>
                    </a>
                  </div>
                </div>
              </div>
              HTML
            end

            it_behaves_like 'returns empty books search results'
          end
        end
      end

      context 'media type album' do
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
                        <div>Artwork</div>
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
      end

      context 'if not a search result' do
        let(:artwork_html) do
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
                    <div>Artwork</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it_behaves_like 'returns empty artworks search results'
      end

      context 'if html is empty' do
        let(:artwork_html) { '' }

        it_behaves_like 'returns empty artworks search results'
      end
    end
  end
end
