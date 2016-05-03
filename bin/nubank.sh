#!/bin/bash

# Baixa os dados da fatura em aberto do Nubank
# Uso:
#   ./nubank.sh <cpf> <senha>

cpf=$1
senha=$2
if [ "$cpf" == "" ]; then
  read -p "Digite o CPF: " cpf
fi
if [ "$senha" == "" ]; then
  read -p "Digite a senha de internet (não é a do cartão): " senha
fi

# faz requisição para pegar client_id e client_secret
resp=$(wget -qO- --post-data='{"name":"Nubank","uri":"https://conta.nubank.com.br"}' --header='Content-Type:application/json' "https://prod-auth.nubank.com.br/api/registration")

clientid=$(echo $resp | sed -r 's/.*"client_id":"([^"]*)".*/\1/')
clientsecret=$(echo $resp | sed -r 's/.*"client_secret":"([^"]*)".*/\1/')

# faz requisição para pegar o token
resp=$(wget -qO- --post-data="{\"grant_type\":\"password\",\"username\":\"${cpf}\",\"password\":\"${senha}\",\"client_id\":\"${clientid}\",\"client_secret\":\"${clientsecret}\",\"nonce\":\"NOT-RANDOM-YET\"}" --header='Content-Type:application/json' "https://prod-auth.nubank.com.br/api/token")
token=$(echo $resp | sed -r 's/.*"access_token":"([^"]*)".*/\1/')

# pega o customer_id (identifica a pessoa)
resp=$(wget -qO- --header="Authorization: Bearer ${token}" "https://prod-customers.nubank.com.br/api/customers")
customerid=$(echo $resp | sed -r 's/id":"([^"]*)".*/\1/' | sed -r 's/.*"(.*)/\1/')

# pega o account_id (identifica o cartão)
resp=$(wget -qO- --header="Authorization: Bearer ${token}" "https://prod-credit-card-accounts.nubank.com.br/api/${customerid}/accounts")
accountid=$(echo $resp | sed -r 's/.*"account_id":"([^"]*)".*/\1/')

# baixa fatura (formato json)
wget -qO- --header="Authorization: Bearer ${token}" "https://prod-accounts.nubank.com.br/api/accounts/${accountid}/bills/open"