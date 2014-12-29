
class Order < ActiveRecord::Base
  has_many :items, class_name: "LineItem"
  has_one :address
  has_one :credit_card
  validates :number, uniqueness: true
  before_create :set_number

  def total
    Money.new items.sum(:total_cents)
  end

  def fedex_options
    HTTParty.get(api_url("FedEx")).parsed_response
  end

  def usps_options
    puts "^"*80, "API URL #{api_url("USPS")}"
    HTTParty.get(api_url("USPS")).parsed_response
  end

  private

    def set_number
      while !self.number || Order.exists?(number: self.number.to_s)
        self.number = create_number
      end
    end

    def create_number
      (SecureRandom.random_number(9000000) + 1000000).to_s
    end

    def api_url(carrier)
      puts "tried to call #{carrier} with query #{query_string}"
      "#{api_host}/shipments.json?carrier=#{carrier}&#{query_string}"
    end

    def query_string
      "#{origin_query}&#{destination_query}&#{packages_query}"
    end

    def origin_query
      { origin: {
          country: 'US',
          state:   'WA',
          city:    'Seattle',
          zip:     '98103'
        }}.to_query
    end

    def destination_query
      { destination: {
        country:  'US',
        state:    address.state,
        city:     address.city,
        zip:      address.postal_code
        }}.to_query
    end

    def packages_query
      packages_hash = {}
      index = 0

      items.each do |line_item|
        item = Product.find(line_item.product_id)
        line_item.quantity.times do
          packages_hash[index] = { weight: item.weight, dimensions: item.dimensions_query }
          index += 1
        end
      end

      packages_hash.to_query(:packages)
    end

    def api_host
      if Rails.env.development?
        "http://localhost:3001"
      else
        "http://frozen-bastion-1170.herokuapp.com"
      end
    end
end
