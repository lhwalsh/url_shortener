require 'rails_helper'

RSpec.describe SitesController, type: :controller do
  describe 'GET encode' do
    let(:url) { 'sample.com/url' }

    context 'when the url param has not been used before' do
      before do
        expect(Site.find_by(name: url)).to be_blank
      end

      it 'creates a new Site model' do
        expect { get :encode, params: { url: url } }.to change { Site.count }.by(1)
        expect(Site.find_by(name: url)).to be_present
      end
    end

    it 'returns an encoded string with numbers, lower case letters, and upper case letter' do
      get :encode, params: { url: url }
      encoded_url = response.body.delete_prefix(SitesController::BASE_URL)
      expect(response.body.start_with?(SitesController::BASE_URL)).to be_truthy
      expect(encoded_url.length).to be < url.length
      expect(encoded_url).to match("^[A-Za-z0-9_-]*$")
    end
  end

  describe 'GET decode' do
    let(:decoded_url) { 'sample.com/url' }
    let!(:site) { Site.create!(name: decoded_url, id: 984727) }
    let(:encoded_id) { subject.send(:encode_id, site.id) }
    let(:encoded_url) { SitesController::BASE_URL + encoded_id }

    it 'returns the name of a Site from the decoded url' do
      get :decode, params: { url: encoded_url }
      expect(response.body).to eq(decoded_url)
    end

    context "when the url doesn't start with the correct base url" do
      let(:encoded_url) { 'wrong.com/start' }

      it 'returns a 400 error' do
        get :decode, params: { url: encoded_url }
        expect(response.code).to eq('400')
        expect(response.body).to eq("Encoded URL must start with #{SitesController::BASE_URL}")
      end
    end
  end
end