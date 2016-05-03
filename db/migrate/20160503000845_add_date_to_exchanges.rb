class AddDateToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :date, :date
  end
end
