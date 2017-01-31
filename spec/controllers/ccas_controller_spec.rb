require 'rails_helper'

describe CcasController do

  before(:all) do
    @original_captcha_pass_value = SimpleCaptcha.always_pass
    SimpleCaptcha.always_pass = true
  end

  after(:all) do
    SimpleCaptcha.always_pass = @original_captcha_pass_value
  end

  describe 'POST create' do
    it 'should create an ahoy event' do

      sign_in create(:user)

      post :create, cca: { title: 'A sample cca', description: 'this is a sample cca', terms_of_service: 1 }
      expect(Ahoy::Event.where(name: :cca_created).count).to eq 1
      expect(Ahoy::Event.last.properties['cca_id']).to eq Cca.last.id

      post :create, medida: { title: 'A sample measure', description: 'this is a sample measure', terms_of_service: 1 }
      expect(Ahoy::Event.where(name: :measure_created).count).to eq 1
      expect(Ahoy::Event.last.properties['measure_id']).to eq Measure.last.id
    end
  end

  describe "Vote with too many anonymous votes" do
    it 'should allow vote if user is allowed' do
      Setting.find_by(key: "max_ratio_anon_votes_on_ccas").update(value: 100)
      cca = create(:cca)
      sign_in create(:user)

      expect do
        xhr :post, :vote, id: cca.id, value: 'yes'
      end.to change { cca.reload.votes_for.size }.by(1)
    end

    it 'should not allow vote if user is not allowed' do
      Setting.find_by(key: "max_ratio_anon_votes_on_ccas").update(value: 0)
      cca = create(:cca, cached_votes_total: 1000)
      sign_in create(:user)

      expect do
        xhr :post, :vote, id: cca.id, value: 'yes'
      end.to_not change { cca.reload.votes_for.size }
    end
  end
end
