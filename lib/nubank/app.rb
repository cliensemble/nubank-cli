require_relative 'helpers/connections.rb'
require 'json'
require 'thor'

module NubankCli
  class App < Thor
  
    package_name 'nbnk'
    
    desc "setup", "Create config and edit with $EDITOR"
    def setup
      Configuration.save
      if !ENV['EDITOR'].to_s.empty? && !ENV['EDITOR'].nil?
        exec "$EDITOR #{ENV['HOME']}/.nubankrc"
      else
        puts "$EDITOR is not set. Please type your editor:"
        editor = STDIN.gets.chomp
        exec "#{editor} #{ENV['HOME']}/.nubankrc"
      end
    end
    
    desc 'fatura', 'Baixa a fatura do mês atual'
    def fatura
      token = Connection.get_token(authenticate)
      customer = Connection.get_customer_id(token)
      account = Connection.get_account_id(customer['customer']['id'], token)
      
      if account['accounts'].length == 1
        content = Connection.get(account['accounts'][0]['_links']['bills_summary']['href'], token)
        File.write('~/fatura.json', content)
      else
        puts 'Escolha uma conta (LOCKED BADGE)'
      end
    end
      
    private
    def authenticate
      puts "Usuário:"
      @user = STDIN.gets.chomp
      puts "Senha:"
      @pass = STDIN.noecho(&:gets).delete("\n")
      
      {'user' => @user, 'pass' => @pass}
    end
  
  end
end