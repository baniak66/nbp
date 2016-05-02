class MoneyController < ApplicationController

  def index
    #show list of exchange rates with creation time
    #don't forget about pagination
    @exchanges = Exchange.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    #show table of currencies for selected exchange rate
    @exchange = Exchange.find(params[:id])
  end

  def refresh_rates
    #for manual refreshing
    #get latest exchange rates and save to db
    #can be helpful:
    #http://www.nbp.pl/home.aspx?f=/kursy/instrukcja_pobierania_kursow_walut.html
    @exchanges = Exchange.all
    ex_before = Exchange.all.count
    @exchange = Exchange.new
    @exchange.save_current_rates
    ex_after = Exchange.all.count
    unless ex_before == ex_after
      redirect_to money_index_path, notice: 'New exchange added!'
    else
      redirect_to money_index_path, flash: {error: 'New exchange not available!'}
    end
  end

  def report
    @currency = Currency.all.where(code: params[:code])
    #generate a report for selected currency
    #report should show: basic statistics: mean, median, average
    #also You can generate a simple chart(use can use some js library)

    #this method should be available only for currencies which exist in the database
  end


end
