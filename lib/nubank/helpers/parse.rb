require 'json'

module NubankCli
    
  # @author Rodrigo Muniz
  class Parse
      
    # Remove as barras invertidas da saída em JSON
    # @param str [String] Saída em JSON no formato String.
    # @return [Hash] Dados no formato JSON sem as barras invertidas.
    def self.parse_json(str)
        parsed = str.gsub "\\", ""
        JSON.parse parsed
    end
      
  end
end