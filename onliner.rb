require 'net/http'
require 'json'
require 'pg'
def build_uri(page)
  URI("https://ab.onliner.by/sdapi/ab.api/search/vehicles?page=#{page}&extended=true&limit=50")
end

class Avto
  attr_accessor :external_id,:manufacturer,:model,:color,:year,:price,:currency,:source
  def initialize(external_id:, manufacturer:, model: , color: , year: ,price:,currency:,source:)
    self.external_id = external_id
    self.manufacturer = manufacturer
    self.model = model
    self.color = color
    self.year = year
    self.price = price
    self.currency = currency
    self.source= source
  end
end

def parse_onliner(page)
  uri = build_uri(page)
  json_data = Net::HTTP.get(uri)
  data = JSON.parse(json_data)
  data_adv = data['adverts']
  p data_adv
  avto_storage=[]
  data_adv.each do |avto|
    avto_storage << Avto.new(external_id: avto['id'],
                             manufacturer: avto['manufacturer']['name'],
                             model: avto['model']['name'],
                             color: avto['specs']['color'],
                             year: avto['specs']['year'],
                             price: avto['price']['amount'],
                             currency: avto['price']['currency'],
                             source: 'onliner')
  end
  avto_storage
end

conn = PG.connect( dbname: 'parser_avto_db' )
50.times do |i|
  puts i
  parse_onliner(i+1).each do |avto|
    conn.exec( "INSERT INTO avto_storage(external_id,
                                manufacturer,
                                model,
                                 color,
                                 year,
                                 price,
                                 currency,
                                 source)
                VALUES (#{avto.external_id},
                          '#{avto.manufacturer}',
                           '#{avto.model}',
                          '#{avto.color}',
                          #{avto.year},
                          #{avto.price},
                          '#{avto.currency}',
                          '#{avto.source}');"
    ) 
    #rescue nil
    end
  end




