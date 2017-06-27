class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
    self.listings.select do |listing|
      listing if !listing.reservations.map do |reservation|
        reservation.checkout <= start_date.to_date && end_date.to_date >= reservation.checkin ? true : false
      end.include?(false)
    end
  end

  def neighborhood_reservations
    self.listings.map do |listing|
      listing.reservations
    end.flatten.size
  end

  def neighborhood_listings
    list = self.listings.flatten.size
    list == 0 ? list = 1 : list
    list
  end

  def ratio
    (self.neighborhood_reservations / self.neighborhood_listings).round(2)
  end

  def self.most_res
    self.all.inject{|old_n, new_n| old_n.neighborhood_reservations > new_n.neighborhood_reservations ? old_n : new_n}
  end

  def self.highest_ratio_res_to_listings
    self.all.inject{|old_n, new_n| old_n.ratio > new_n.ratio ? old_n : new_n}
  end

end
