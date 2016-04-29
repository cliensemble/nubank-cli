require 'thor'

module NubankCli
    class App < Thor
        
        desc 'teste', 'teste'
        def teste
            puts 'teste'
        end
        
    end
end