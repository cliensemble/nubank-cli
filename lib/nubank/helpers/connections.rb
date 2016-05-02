require 'curb'
require 'json'
require_relative 'parse'

module NubankCli
    
    class Connection
    
      URL = "https://prod-auth.nubank.com.br/api/registration"
      POST_DATA = {'name' => 'Nubank', 'uri' => 'https://conta.nubank.com.br'}
        
      def self.login
        c = Curl::Easy.http_post(URL, POST_DATA.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        Parse.parse_json c.body_str
      end
        
    end
end