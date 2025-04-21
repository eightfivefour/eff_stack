class ListRailsGeneratorsTool < ActionTool::Base
  description "List all Rails generators"

  def call(**)
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
    
    { generators: categories }
  end
end
