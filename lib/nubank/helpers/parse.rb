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
      
    # Formata a lista de faturas dentro do período de um ano
    # @param json_file [Hash] Fatura do mês corrente no formato JSON.
    # @return [String] Dados da fatura formatados.
    def self.fatura_formatada(json_file)
        json_file['bills'].each do |j|
          puts "Status: #{j['state']}"
          puts "Details: #{j['summary']['due_date']}"
        end
    end
      
    # Formata a fatura do mês corrente
    # @param json_file [Hash] Fatura do mês corrente no formato JSON.
    # @return [String] Dados da fatura formatados.
    def self.fatura_atual_formatada(json_file)
        json_file['bill']['line_items'].each do |j|
          data = Date.strptime(j['post_date'], "%Y-%m-%d")
          puts "Data: #{data[:mday]}/#{data[:mon]}/#{data[:year]}"
          puts "Estabelecimento: #{j['title']}"
          puts "Gasto: R$ #{self.formatar_moeda(j["amount"])}"
          puts "\n"
        end
    end
    
    def self.formatar_moeda(valor)
      valor.to_s.insert(-3, ",")
    end
      
  end
end