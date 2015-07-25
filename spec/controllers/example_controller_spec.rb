describe Api::V1::ExampleController, type: :controller do
  before :each do
    sign_in FactoryGirl.create(:confirmed_user)
  end

  describe "#example" do
    it 'returns successfully' do
      get :example
      json = JSON.parse(@response.body)
      expect(json["message"]).to eql Api::V1::ExampleController::MESSAGE
    end

    it 'returns 200' do
      get :example
      expect(@response.code.to_i).to eql 200
    end
  end
end
