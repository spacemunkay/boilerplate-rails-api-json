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
      expect(json_response["error"]).
        to eql "You have to confirm your email address before continuing."
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

context "User Sign-In" do
  describe "api/v1/users/sign_in" do
    let(:user) { FactoryGirl.create(:confirmed_user) }
    let(:json_data) { {user: { email: user.email, password: user.password}} }

    it "returns 201 status code" do
      post "/api/v1/users/sign_in", json_data, format: :json
      expect(response.code.to_i).to eql 201
    end

    it "returns a valid auth token" do
      post "/api/v1/users/sign_in", json_data, format: :json
      json_response = JSON.parse(response.body)
      auth_token = json_response["authentication_token"]
      expect(auth_token).to_not be_nil

      headers = { format: :json,
                  "X-User-Token" => auth_token,
                  "X-User-Email" => user.email}
      get "api/v1/example", nil, headers
      expect(response.code.to_i).to eql 200
    end

    context "when performing actions without an auth token" do
      it "errors with a 401 and message" do
        get "api/v1/example"
        expect(response.code.to_i).to eql 401
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).
          to eql "You need to sign in or sign up before continuing."
      end
    end

    context "when performing actions with an invalid auth token" do
      it "errors with a 401 and message" do
        headers = { format: :json,
                    "X-User-Token" => 'adswflkjadsf',
                    "X-User-Email" => user.email}
        get "api/v1/example", nil, headers
        expect(response.code.to_i).to eql 401
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).
          to eql "You need to sign in or sign up before continuing."
      end
    end
  end
end

context "User Sign Out (Renew Token)" do
  describe "api/v1/users/sign_in" do
    context "when a user is already signed in" do
      let(:user) { FactoryGirl.create(:confirmed_user) }
      let(:json_data) { {user: { email: user.email, password: user.password}} }

      before do
        post "/api/v1/users/sign_in", json_data, format: :json
        json_response = JSON.parse(response.body)
        @auth_token = json_response["authentication_token"]
        assert @auth_token != nil
      end

      it "invalidates the old auth token" do
        #Sign out
        headers = { format: :json,"X-User-Token" => @auth_token, "X-User-Email" => user.email}
        delete 'api/v1/users/sign_out', nil, headers

        # Attempt an action using the old auth token
        headers = { format: :json,
                    "X-User-Token" => @auth_token,
                    "X-User-Email" => user.email}
        get "api/v1/example", nil, headers
        expect(response.code.to_i).to eql 401
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).
          to eql "You need to sign in or sign up before continuing."
      end
    end

    context "when not signed in" do
      it 'returns a 401' do
        delete 'api/v1/users/sign_out', nil, headers
        expect(response.code.to_i).to eql 401
      end
    end
  end
end
