require 'nubank/helpers/connections.rb'
require 'nubank/helpers/parse.rb'
require 'json'
require 'thor'

module NubankCli
  
  # @author Rodrigo Muniz
  class App < Thor
    
    @@token, @@cliente, @@conta = nil

    package_name 'nbnk'
    
    # desc "setup", "Create config and edit with $EDITOR"
    # def setup
    #   Configuration.save
    #   if !ENV['EDITOR'].to_s.empty? && !ENV['EDITOR'].nil?
    #     exec "$EDITOR #{ENV['HOME']}/.nubankrc"
    #   else
    #     puts "$EDITOR is not set. Please type your editor:"
    #     editor = STDIN.gets.chomp
    #     exec "#{editor} #{ENV['HOME']}/.nubankrc"
    #   end
    # end
    
    desc 'fatura', 'Baixa a fatura do mês atual'
    # Baixa a fatura do mês corrente no formato JSON 
    def fatura
      obter_conta()
      
      if @@conta['accounts'].length == 1
        content = Connection.get(@@conta['accounts'][0]['_links']['bills_summary']['href'], @@token)
        # File.write('fatura.json', content)
        Parse.fatura_formatada content
      else
        puts 'Escolha uma conta (LOCKED BADGE)'
      end
    end
    
    desc 'fatura detalhada', 'Exibe os detalhes da fatura do mês atual'
    # Baixa a fatura do mês corrente no formato JSON 
    def fatura_detalhada
      obter_conta()
      
      if @@conta['accounts'].length == 1
        content = Connection.get(@@conta['accounts'][0]['_links']['bills_summary']['href'], @@token)
        fatura_atual = Connection.get(content["_links"]["open"]["href"], @@token)
        # File.write('fatura.json', fatura_atual)
        Parse.fatura_atual_formatada fatura_atual
      else
        puts 'Escolha uma conta (LOCKED BADGE)'
      end
    end

    # Coleta o nome de usuário (CPF) e senha para acesso ao sistema do Nubank.
    #
    # @return [Hash] CPF e senha vindos da entrada de dados.
    private
    def autenticar
      puts "Usuário:"
      @user = STDIN.gets.chomp
      puts "Senha:"
      @pass = STDIN.noecho(&:gets).delete("\n")
      
      {'user' => @user, 'pass' => @pass}
    end

    # Pega os dados do cliente e os define para uma variável de classe.
    private
    def obter_cliente
      @@token = Connection.get_token(autenticar)
      @@cliente = Connection.get_customer_id(token)
    end
      
    # Pega os dados da(s) conta(s) do cliente logado e os define para uma variável de classe.
    private
    def obter_conta
      @@token = Connection.get_token(autenticar)
      @@cliente = Connection.get_customer_id(@@token)
      @@conta = Connection.get_account_id(@@cliente['customer']['id'], @@token)
    end
  
  end
end