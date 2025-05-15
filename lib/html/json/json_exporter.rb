require 'json'

class JsonExporter
  def export(arr)
    File.open('out.json', 'w') do |f|
      f.write(JSON.pretty_generate(arr.map(&:to_h)))
    end
  end
end