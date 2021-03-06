class Exchange < ActiveRecord::Base
  require 'open-uri'

  has_many :currencies
  accepts_nested_attributes_for :currencies

  validates :name, presence: true
  validates :name, uniqueness: true

  def get_nbp_xml(file='LastC')
    download = open("http://www.nbp.pl/kursy/xml/#{file}.xml")
    # IO.copy_stream(open('http://www.nbp.pl/kursy/xml/LastC.xml'), 'LastC.xml')
    ex_hash = Hash.from_xml(download)
    ex_name = ex_hash['tabela_kursow']['numer_tabeli']
    ex_date = ex_hash['tabela_kursow']['data_notowania']
    positions = ex_hash['tabela_kursow']['pozycja']
    key_map = { 'nazwa_waluty' => 'name',
                'przelicznik' => 'converter',
                'kod_waluty' => 'code',
                'kurs_kupna' => 'buy_price',
                'kurs_sprzedazy' => 'sell_price' }

    positions.map! do |p|
      p.map {|k, v| [key_map[k], v] }.to_h
    end

    positions.each do |p|
      p.fetch('buy_price').gsub!(',', '.')
      p.fetch('sell_price').gsub!(',', '.')
    end

    params = { exchange: {
      name: ex_name, date: ex_date, currencies_attributes: [
        positions
      ][0]
    }}
  end

  def save_current_rates
    Exchange.create(get_nbp_xml[:exchange])
  end

  def get_txt
    download = open("http://www.nbp.pl/kursy/xml/dir.txt")
    IO.copy_stream(download, 'dir.txt')
    array = IO.readlines 'dir.txt'
  end

end
