require 'json'

class JsonExporter
  def export(output_path, obj)
    File.open(output_path, 'w') do |f|
      f.write(JSON.pretty_generate(obj.to_h))
    end
  end
end