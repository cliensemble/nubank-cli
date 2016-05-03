require 'curb'
require 'json'
require_relative 'parse'

module NubankCli
    
    class Connection
    
      URL_CLIENT_SECRET = "https://prod-auth.nubank.com.br/api/registration"
      POST_CLIENT_SECRET = {'name' => 'Nubank', 'uri' => 'https://conta.nubank.com.br'}
      URL_TOKEN = "https://prod-auth.nubank.com.br/api/token"
      POST_TOKEN = {'grant_type' => 'password', 'username' => '', 'password' => '', 'client_id' => '',
        'client_secret' => '', 'nonce' => 'NOT-RANDOM-YET'
      }
      URL_CUSTOMER = "https://prod-customers.nubank.com.br/api/customers"
      URL_ACCOUNT = "https://prod-credit-card-accounts.nubank.com.br/api"
        
      def self.get_client_secret
        c = Curl::Easy.http_post(URL_CLIENT_SECRET, POST_CLIENT_SECRET.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        data = Parse.parse_json(c.body_str)
        
        POST_TOKEN['client_id'] = data['client_id']
        POST_TOKEN['client_secret'] = data['client_secret']
      end
        
      def self.get_token(auth_data)
        self.get_client_secret
        
        POST_TOKEN['username'] = auth_data['user']
        POST_TOKEN['password'] = auth_data['pass']
        c = Curl::Easy.http_post(URL_TOKEN, POST_TOKEN.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        t = Parse.parse_json(c.body_str)
        t['access_token']
      end
        
      def self.get_customer_id(token)
        c = Curl.get(URL_CUSTOMER) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
        
        Parse.parse_json c.body_str
      end
        
      def self.get_account_id(customer_id, token)
        url = "#{URL_ACCOUNT}/#{customer_id}/accounts"
        c = Curl.get(url) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
        
        Parse.parse_json c.body_str
      end

      def self.get(url, token)
        c = Curl.get(url) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
    
        Parse.parse_json c.body_str
      end
        
    end
end