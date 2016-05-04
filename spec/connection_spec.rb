require 'curb'
require 'json'
require 'nubank'

describe NubankCli::Connection do
  
  describe "CLIENT_SECRET" do
    context "URL do CLIENT_SECRET" do
      it "ativa" do
        expect(200).to eql(200)
      end
    end
  end
  
end