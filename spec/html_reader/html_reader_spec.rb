require_relative '../../lib/html/html_reader'

RSpec.describe HtmlReader do
  context "testing basic assertions" do
    it "passes when true" do
      expect(true).to eq true
    end

    it "fails when false" do
      expect(false).to eq true
    end
  end
end