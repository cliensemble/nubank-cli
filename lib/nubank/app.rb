load 'helpers/connections.rb'
require 'thor'

module NubankCli
  class App < Thor
  
    package_name 'tpl'
    
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
    
    desc 'teste', 'teste'
    def teste
      puts 'teste'
    end
    
    # private
    def login
      puts "Usuário:"
      @user = STDIN.gets.chomp
      puts "Senha:"
      @pass = STDIN.gets.chomp
      
      Connection.login
    end
  
  end
end