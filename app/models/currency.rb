class Currency < ActiveRecord::Base
  belongs_to :exchange

  validates :name, :converter, :code, :buy_price, :sell_price, presence: true
end
