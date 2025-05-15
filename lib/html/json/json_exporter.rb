require 'json'

class JsonExporter
  def export(obj)
    File.open('files/results.json', 'w') do |f|
      f.write(JSON.pretty_generate(obj.to_h))
    end
  end
end