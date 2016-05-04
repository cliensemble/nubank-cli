require 'curb'
require 'json'
require_relative 'parse'

module NubankCli
    
    # @author Rodrigo Muniz
    class Connection
    
      # URL para se obter o CLIENT_SECRET
      URL_CLIENT_SECRET = "https://prod-auth.nubank.com.br/api/registration"
      # Dados do POST para a URL do CLIENT_SECRET
      POST_CLIENT_SECRET = {'name' => 'Nubank', 'uri' => 'https://conta.nubank.com.br'}
      # URL para se obter o token
      URL_TOKEN = "https://prod-auth.nubank.com.br/api/token"
      # Dados do POST para a URL de token
      POST_TOKEN = {'grant_type' => 'password', 'username' => '', 'password' => '', 'client_id' => '',
        'client_secret' => '', 'nonce' => 'NOT-RANDOM-YET'
      }
      # URL para se obter os dados do cliente
      URL_CUSTOMER = "https://prod-customers.nubank.com.br/api/customers"
      # URL para se obter os dados das contas do cliente
      URL_ACCOUNT = "https://prod-credit-card-accounts.nubank.com.br/api"

      # Obtém o CLIENT_SECRET, uma string necessária para obtenção do token.
      def self.get_client_secret
        c = Curl::Easy.http_post(URL_CLIENT_SECRET, POST_CLIENT_SECRET.to_json) do |curl|
          curl.headers["Content-Type"] = "application/json"
        end
        
        data = Parse.parse_json(c.body_str)
        
        POST_TOKEN['client_id'] = data['client_id']
        POST_TOKEN['client_secret'] = data['client_secret']
      end

      # Obtém o token para autorização das transações.
      # @param auth_data [Hash] Nome de usuário (CPF) e senha para autenticação.
      # @return [String] String do token para autorização.
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

      # Obtém os dados disponíveis do cliente.
      # @param token [String] Token de autorização.
      # @return [Hash] Dados de cliente.
      def self.get_customer_id(token)
        c = Curl.get(URL_CUSTOMER) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
        
        Parse.parse_json c.body_str
      end

      # Obtém os dados das contas disponíveis por cliente.
      # @param customer_id [String] ID do cliente.
      # @param token [String] Token de autorização.
      # @return [Hash] Dados das contas de cliente.
      def self.get_account_id(customer_id, token)
        url = "#{URL_ACCOUNT}/#{customer_id}/accounts"
        c = Curl.get(url) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
        
        Parse.parse_json c.body_str
      end

      # Obtém informações diversas de acordo com o link fornecido.
      # @param url [String] URL da transação.
      # @param token [String] Token de autorização.
      # @return [Hash] Resultado da transação em formato JSON.
      def self.get(url, token)
        c = Curl.get(url) do |curl|
          curl.headers["Authorization"] = "Bearer #{token}"
        end
    
        Parse.parse_json c.body_str
      end
        
    end
end