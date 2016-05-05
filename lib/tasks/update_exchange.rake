desc "Check for new exchange and update"
task :update_exchange => :environment do
  ex_before = Exchange.all.count
  ExchangeUpdateWorker.new.perform
  ex_after = Exchange.all.count
  unless ex_before == ex_after
    UserNotifyWorker.perform_async
  end
end
