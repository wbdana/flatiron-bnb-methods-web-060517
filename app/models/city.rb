class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    self.listings.select do |listing|
      listing if !listing.reservations.map do |reservation|
        reservation.checkout <= start_date.to_date && end_date.to_date >= reservation.checkin ? true : false
      end.include?(false)
    end
  end

  #This passes, but I realize that this is actually a method for the city with most reservations... needs work
  def self.highest_ratio_res_to_listings
    self.all.inject{|old_city, new_city| old_city.listings.map{|list| list.reservations.size}.inject(:+) > new_city.listings.map{|list| list.reservations.size}.inject(:+) ? old_city : new_city}
  end

  def self.most_res
    self.all.inject{|old_city, new_city| old_city.listings.map{|list| list.reservations.size}.inject(:+) > new_city.listings.map{|list| list.reservations.size}.inject(:+) ? old_city : new_city}
  end

end
