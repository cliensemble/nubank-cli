require 'json'

module NubankCli
    class Parse
        
        def self.parse_json(str)
            parsed = str.gsub "\\", ""
            JSON.parse parsed
        end
        
    end
end