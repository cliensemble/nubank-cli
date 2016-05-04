require 'nubank/helpers/connections'

describe Connection do
  
  describe "CLIENT_SECRET" do
    context "Tenta pegar o CLIENT_SECRET" do
      it "consegue" do
        expect(Connection.get_token()).not_to be_empty
      end
    end
  end
  
end