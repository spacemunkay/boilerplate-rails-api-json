describe "User Registration" do
  context "/api/v1/users" do
    let(:user) { FactoryGirl.build(:user) }
    let(:json_data) { {user: { email: user.email, password: user.password}} }

    it "returns 201 status code" do
      post "/api/v1/users", json_data, format: :json
      expect(response.code.to_i).to eql 201
    end

    it "requires confirmation before allowing access" do
      post "/api/v1/users", json_data, format: :json

      post "/api/v1/users/sign_in", json_data, format: :json
      expect(response.code.to_i).to eql 401
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eql "You have to confirm your email address before continuing."
    end

    it "sends an email for confirmation" do
      json_data = { user: { email: user.email, password: user.password } }
      expect{post "/api/v1/users", json_data, format: :json}.
        to change{ActionMailer::Base.deliveries.length}.from(0).to(1)
    end
  end
end

context "User Confirmation" do
  describe "api/v1/users/confirmation" do
    let(:user) { FactoryGirl.build(:user) }

    before :each do
      json_data = { user: { email: user.email, password: user.password } }
      post "/api/v1/users", json_data, format: :json
      email = ActionMailer::Base.deliveries.last
      @token = email.body.match(/confirmation_token=(.+)'>/x)[1]
    end

    it "returns 200 status code" do
      get "api/v1/users/confirmation?confirmation_token=#{@token}"
      expect(response.code.to_i).to eql 200
    end

    it "returns a body with an email and auth token" do
      get "api/v1/users/confirmation?confirmation_token=#{@token}"

      json_response = JSON.parse(response.body)
      expect(json_response['email']).to eql user.email

      auth_token = User.find_by_email(user.email).authentication_token
      expect(json_response['authentication_token']).to eql auth_token
    end
  end
end
