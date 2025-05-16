require 'json'
require 'nokogiri'

require_relative '../../lib/html/html_parser'
require_relative '../../lib/html/search_result_types/artwork'
require_relative '../../lib/html/search_result_types/search_results'

RSpec.describe HtmlParser do
  describe "end-to-end parsing" do
    let(:html_path) { File.expand_path("files/van-gogh-paintings.html", __dir__) }
    let(:expected_json_path) { File.expand_path("files/expected-array.json", __dir__) }
    let(:results_json_path) { File.expand_path("files/results.json", __dir__) }

    it "parses HTML and matches expected results" do
      html = File.read(html_path)
      expected = JSON.parse(File.read(expected_json_path))
      results = HtmlParser.parse(html)
      File.write(results_json_path, JSON.pretty_generate(results.to_h))
      actual = JSON.parse(File.read(results_json_path))

      expect(actual).to eq(expected)
    end
  end
end