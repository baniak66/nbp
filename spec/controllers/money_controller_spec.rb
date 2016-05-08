require 'spec_helper'

RSpec.describe MoneyController, type: :controller do

  let(:user) { FactoryGirl.create :user}
  let(:exchange) { FactoryGirl.create :exchange}
  let(:currency) { FactoryGirl.create :currency, exchange_id: exchange.id}

  describe "GET #index" do
    it 'should display exchanges list' do
      get :index
      expect( response ).to render_template(:index)
    end
  end

  describe "GET #show" do
    it 'should display exhcange details' do
      get :show, id: exchange.id
      expect( response ).to render_template(:show)
    end
  end

  describe "GET #report" do

    describe "Logged user" do

      before :each do
        sign_in user
      end

      it 'should display currency report' do
        get :report, code: currency.code
        expect( response ).to render_template(:report)
      end
    end

    describe "Anonymous user" do

      it 'should redirect to login page' do
        get :report, code: currency.code
        expect( response ).to redirect_to( new_user_session_path)
      end
    end
  end

  describe "GET #currency" do
    it 'should display list of currency rates' do
      get :currency, code: currency.code
      expect( response ).to render_template(:currency)
    end
  end

end
