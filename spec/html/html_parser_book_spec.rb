# frozen_string_literal: true

require 'nokogiri'
require_relative '../../lib/html/html_parser'
require_relative '../../lib/html/search_result_types/search_results'


RSpec.shared_examples 'returns empty books search results' do
  it 'returns empty books search results' do
    results = HtmlParser.parse(book_html)
    expect(results.books).to eq([])
  end
end

RSpec.describe HtmlParser do
  describe '.parse' do
    context 'html contains search results' do
      context 'html contains img src' do
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

      context 'html contains img data-src' do
        let(:book_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Books</span>
            </div>
            <div>
              <div>
                <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=The+Stand&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                  <img class="taFZJe" alt="The Stand" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                  <div class="KHK6lb">
                    <div class="pgNMRc">The Stand</div>
                    <div class="cxzHyb">1978</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
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
          expect(book.name).to eq('The Stand')
          expect(book.extensions).to include('1978')
          expect(book.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Stand&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
          expect(book.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
          expect(book.image_id).to eq(nil)
        end
      end

      context 'contains no extensions' do
        let(:book_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Books</span>
            </div>
            <div>
              <div>
                <a href="/search?test">
                  <img id="imgid3" src="data:image/png;base64,AAA" />
                  <div>
                    <div>Book With No Extensions</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it 'parses book with an empty extensions array' do
          results = HtmlParser.parse(book_html)
          book = results.books.first
          expect(book.extensions).to eq([])
        end
      end

      context 'contains multiple extensions' do
        let(:book_html) do
          <<-HTML
          <div jsname="test">
            <div>
              <span>Books</span>
            </div>
            <div>
              <div>
                <a href="/search?test">
                  <img id="imgid2" src="data:image/png;base64,AAA" />
                  <div>
                    <div>Book With Two Extensions</div>
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
          results = HtmlParser.parse(book_html)
          book = results.books.first
          expect(book.extensions.size).to eq(2)
          expect(book.extensions).to eq(%w[Medium Year])
        end
      end

      context 'search results can contain multiple books' do
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
            <div>
              <div>
                <a href="/search?sca_esv=c2e426814f4d07e9&amp;gl=us&amp;hl=en&amp;q=The+Stand&amp;stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&amp;sa=X&amp;ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV">
                  <img class="taFZJe" alt="The Stand" data-src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///////yH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==">
                  <div class="KHK6lb">
                    <div class="pgNMRc">The Stand</div>
                    <div class="cxzHyb">1978</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          <script nonce="xmO6un4J9murPFDygFfaMA">(function(){var s='data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG\x3d';var ii=['_EX4naN38EKah5NoPkYvN2Qc_89'];var r='';_setImagesSrc(ii,s,r);})();</script>
          HTML
        end

        it 'returns a SearchResults object' do
          results = HtmlParser.parse(book_html)
          expect(results).to be_a(SearchResults)
        end

        it 'parses books into results.books' do
          results = HtmlParser.parse(book_html)
          expect(results.books.length).to eq(2)
        end

        it 'parses img src books with script src' do
          results = HtmlParser.parse(book_html)
          book = results.books.first
          expect(book.name).to eq('The Shining')
          expect(book.extensions).to include('1977')
          expect(book.link).to eq('https://www.google.com/search?client=firefox-b-1-d&sca_esv=7ce7144faa458147&sxsrf=AHTn8zoEwNBGiIfsFDahq3jpdoxu1s8jbg:1747418641283&q=The+Shining+(novel)&stick=H4sIAAAAAAAAAONgFuLSz9U3yCqxNEgzVeIAsc2Ty4q0pLKTrfST8vOz9RNLSzLyi6xA7GKF_LycykWswiEZqQrBGZl5mXnpChp5-WWpOZoAO7LiS0oAAAA&sa=X&ved=2ahUKEwidyYzbyaiNAxWmEFkFHZFFM3sQ9OUBegQIUBAF')
          expect(book.image).to eq('data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMTEhUTExQWFhUXGRsbGBgYGB8eGxgYGSAXG=')
          expect(book.image_id).to eq('_EX4naN38EKah5NoPkYvN2Qc_89')
        end

        it 'parses img data-src books' do
          results = HtmlParser.parse(book_html)
          book = results.books[1]
          expect(book.name).to eq('The Stand')
          expect(book.extensions).to include('1978')
          expect(book.link).to eq('https://www.google.com/search?sca_esv=c2e426814f4d07e9&gl=us&hl=en&q=The+Stand&stick=H4sIAAAAAAAAAONgFuLQz9U3MI_PNVLiArEsi02MCtO0lLKTrfTLMotLE3PiE4tKkJiZxSVW5flF2cWLWAWcUlOK8vNzFTLzFByLclKLAbk5OxpPAAAA&sa=X&ved=2ahUKEwjK-K-JwLWKAxXcQTABHePpOFoQtq8DegQIMxAV')
          expect(book.image).to eq('https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcScFSw_R642g88BNxROXma6X_J9MND_-6hjZa6BrYq1GNaHC8f3')
          expect(book.image_id).to eq(nil)
        end
      end
    end

    context 'html does not contain search results' do
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
                      <div>Book</div>
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

      context 'if not a search result' do
        let(:book_html) do
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
                    <div>Book</div>
                  </div>
                </a>
              </div>
            </div>
          </div>
          HTML
        end

        it_behaves_like 'returns empty books search results'
      end

      context 'if html is empty' do
        let(:book_html) { '' }

        it_behaves_like 'returns empty books search results'
      end
    end
  end
end
