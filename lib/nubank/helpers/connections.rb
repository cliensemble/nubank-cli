require 'curb'
require 'json'
require_relative 'parse'

module NubankCli
    
    class Connection
    
      URL_CLIENT_SECRET = "https://prod-auth.nubank.com.br/api/registration"
      POST_CLIENT_SECRET = {'name' => 'Nubank', 'uri' => 'https://conta.nubank.com.br'}
      URL_TOKEN = "https://prod-auth.nubank.com.br/api/registration"
      POST_TOKEN = {'grant_type' => 'password', 'username' => '', 'password' => '', 'client_id' => '',
        'client_secret' => '', 'nonce' => 'NOT-RANDOM-YET'
      }
      
      def self.login(username, password)
        client_data = self.get_client_secret
        
        POST_TOKEN['username'] = username
        POST_TOKEN['password'] = password
        POST_TOKEN['client_id'] = client_data['client_id']
        POST_TOKEN['client_secret'] = client_data['client_secret']
        token = self.get_token client_data
      end
        
      def self.get_client_secret
        c = Curl::Easy.http_post(URL_CLIENT_SECRET, POST_CLIENT_SECRET.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        Parse.parse_json(c.body_str)
      end
        
      def self.get_token(data)
        c = Curl::Easy.http_post(URL_TOKEN, POST_TOKEN.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        Parse.parse_json(c.body_str)
      end
        
    end
end