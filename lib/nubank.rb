require 'nubank/app'
require 'nubank/version'
require 'nubank/configuration'

module NubankCli
    def self.config
        NubankCli::Configuration.instance
    end
end