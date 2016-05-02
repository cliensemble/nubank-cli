require 'json'

module NubankCli
    class Parse
        
        def self.parse_json(string)
            string.chomp("\\").to_json
        end
        
    end
end