require 'routes/api_constraints'

describe Routes::ApiConstraints do
  subject { Routes::ApiConstraints }
  let(:api_constraints_v1) { subject.new(version: 1) }
  let(:api_constraints_v2) { subject.new(version: 2, default: true) }

  describe "matches?" do

    it "returns true when the version matches the 'Accept' header" do
      request = double(host: 'localhost',
                       headers: {"Accept" => "application/#{APP_NAME.downcase}.v1"})
      expect(api_constraints_v1.matches?(request)).to eql true
    end

    it "returns the default version when 'default' option is specified" do
      request = double(host: 'localhost')
      expect(api_constraints_v2.matches?(request)).to eql true
    end
  end
end
