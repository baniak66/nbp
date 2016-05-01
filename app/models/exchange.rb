class Exchange < ActiveRecord::Base
  require 'open-uri'

  has_many :currencies
  accepts_nested_attributes_for :currencies

  def get_nbp_xml
    download = open('http://www.nbp.pl/kursy/xml/LastC.xml')
    # IO.copy_stream(open('http://www.nbp.pl/kursy/xml/LastC.xml'), 'LastC.xml')
    ex_hash = Hash.from_xml(download)
    ex_name = ex_hash['tabela_kursow']['numer_tabeli']
    positions = ex_hash['tabela_kursow']['pozycja']
    key_map = { 'nazwa_waluty' => 'name',
                'przelicznik' => 'converter',
                'kod_waluty' => 'code',
                'kurs_kupna' => 'buy_price',
                'kurs_sprzedazy' => 'sell_price' }

    positions.map! do |p|
      p.map {|k, v| [key_map[k], v] }.to_h
    end
    params = { exchange: {
      name: ex_name, currencies_attributes: [
        positions
      ][0]
    }}
  end

  def save_current_rates
    Exchange.create(get_nbp_xml[:exchange])
  end


end
