desc "Check for new exchange and update"
task :update_exchange => :environment do
  ExchangeUpdateWorker.new.perform
end
