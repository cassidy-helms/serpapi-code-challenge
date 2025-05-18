# frozen_string_literal: true

require 'json'

# Exports Ruby objects as JSON files.
#
# Usage:
#   exporter = JsonExporter.new
#   exporter.export('output.json', my_object)
#
# The object passed to #export must respond to #to_h.
class JsonExporter
  # Writes the given object's hash representation to the specified file as JSON.
  #
  # @param output_path [String] the file path to write the JSON output
  # @param obj [Object] an object that responds to #to_h
  def export(output_path, obj)
    File.open(output_path, 'w') do |f|
      f.write(JSON.pretty_generate(obj.to_h))
    end
  end
end
