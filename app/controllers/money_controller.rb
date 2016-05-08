class MoneyController < ApplicationController

  def index
    @exchanges = Exchange.paginate(:page => params[:page], :per_page => 10).order('date DESC')
  end

  def show
    @exchange = Exchange.find(params[:id])
  end

  def refresh_rates
    @exchanges = Exchange.all
    ex_before = Exchange.all.count
    @exchange = Exchange.new
    @exchange.save_current_rates
    ex_after = Exchange.all.count
    unless ex_before == ex_after
      UserNotifyWorker.perform_async
      redirect_to money_index_path, notice: 'New exchange added!'
    else
      redirect_to money_index_path, notice: 'New exchange not available!'
    end
  end

  def report
    @currencies = Currency.all.where(code: params[:code]).limit(10)
  end

  def currency
    @currencies = Currency.paginate(:page => params[:page], :per_page => 15).where(code: params[:code])
    @currency = @currencies.first
  end

end
