class ListRailsGeneratorsTool < ActionTool::Base
  description "List all Rails generators"

  def call(**)
    cache_path = Rails.root.join("tmp/generator_list.json")
    
    if File.exist?(cache_path) && File.mtime(cache_path) > 24.hours.ago
      return JSON.parse(File.read(cache_path)).deep_symbolize_keys
    end
    
    output = `bin/rails generate`
    
    categories = {}
    current_category = nil
    
    output.each_line do |line|
      line = line.strip
      
      if line.empty? || line.start_with?("Usage:") || line.start_with?("General options:") || 
         line.start_with?("-") || line.start_with?("Please choose")
        next
      elsif line.end_with?(":") # This is a category
        current_category = line.chomp(":")
        categories[current_category] = []
      elsif current_category && !line.empty?
        # This is a generator under the current category
        categories[current_category] << line
      end
    end
    
    # Add help content for each generator
    generator_details = {}
    
    categories.each do |category, generators|
      generator_details[category] = {}
      
      generators.each do |generator|
        # Extract generator name from possible formatted output
        generator_name = generator.split.first
        help_output = `bin/rails generate #{generator_name} --help`
        
        generator_details[category][generator_name] = {
          full_name: generator,
          help_content: help_output.strip
        }
      end
    end
    
    result = { 
      generators: categories,
      generator_details: generator_details
    }
    
    # Cache the result to tmp/generator_list.json
    FileUtils.mkdir_p(File.dirname(cache_path))
    File.write(cache_path, result.to_json)
    
    result
  end
end
