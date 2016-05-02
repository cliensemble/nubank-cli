require 'json'

module NubankCli
    class Parse
        
        def self.parse_json(string)
            JSON.parse(string.chomp("\\"))
        end
        
    end
end