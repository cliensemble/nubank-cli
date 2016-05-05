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
      
    # Remove as barras invertidas da saída em JSON
    # @param json_file [Hash] Fatura do mês corrente no formato JSON.
    # @return [String] Dados da fatura formatados.
    def self.fatura_formatada(json_file)
        json_file['bills'].each do |j|
          puts "Status: #{j['state']}"
          puts "Details: #{j['summary']['due_date']}"
        end
    end
      
  end
end