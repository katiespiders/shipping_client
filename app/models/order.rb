
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
    HTTParty.get("http://frozen-bastion-1170.herokuapp.com/shipments")
  end

  #private

    def set_number
      while !self.number || Order.exists?(number: self.number.to_s)
        self.number = create_number
      end
    end

    def create_number
      (SecureRandom.random_number(9000000) + 1000000).to_s
    end

    def to_query_string

    end

    def origin_query
      { origin: {
          country: 'US',
          state:   'WA',
          city:    'Seattle',
          zip:     '98103'
        }}.to_query
    end

    # def packages
    #   @packages_array = []
    #   items.each do |line_item|
    #     item = Product.find(line_item.product_id)
    #     line_item.quantity.times do
    #       @packages_array << Package.new(item.weight, item.dimensions)
    #     end
    #   end
    # end

    def packages_query
      packages_hash = {}
      index = 0

      items.each do |line_item|
        item = Product.find(line_item.product_id)
        line_item.quantity.times do
          packages_hash[index] = { weight: item.weight, dimensions: item.dimensions }
          index += 1
        end
      end
      puts "#"*80
      packages_hash.each {|k, v| puts v[:dimensions]}

      puts "@"*80, Rack::Utils.parse_nested_query(packages_hash.to_query(:packages))
      packages_hash.to_query(:packages)
    end
    #
    # def destination
    #   Location.new(
    #     country: 'US',
    #     zip: address.postal_code,
    #     state: address.state,
    #     city: address.city
    #   )
    # end

    def destination_query
      # state = address.state
      # city = address.city.gsub!(" ", "%20")
      # zip = address.postal_code
      # "destination[country]=US&destination[state]=#{state}&destination[city]=#{city}&destination[zip]=#{zip}"
      { destination: {
        country:  'US',
        state:    address.state,
        city:     address.city,
        zip:      address.postal_code
        }}.to_query
    end



end
