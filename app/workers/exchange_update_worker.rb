class ExchangeUpdateWorker
  include Sidekiq::Worker

  def perform
    e = Exchange.new
    e.save_current_rates
  end
end
