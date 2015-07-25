describe "V1::Example" do
  context "when unauthorized" do
    describe "/api/v1/example" do
      before do
        get subject
      end

      it "returns an unauthorized 401 status code" do
        expect(response.code.to_i).to eql 401
      end
    end
  end
end
