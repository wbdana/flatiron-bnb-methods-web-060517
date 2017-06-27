class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
    self.listings.map do |listing|
      listing.reservations.map do |res|
        res.guest_id
      end
    end.flatten.map do |id|
      User.find_by_id(id)
    end
  end

  def hosts
    self.reviews.map do |review|
      review.reservation_id
    end.map do |res_id|
      Reservation.find_by_id(res_id)
    end.map do |reservation|
      reservation.listing_id
    end.map do |listing_id|
      Listing.find_by_id(listing_id)
    end.map do |listing|
      listing.host_id
    end.map do |host_id|
      User.find_by_id(host_id)
    end
  end

  def host_reviews
    # binding.pry
    self.listings.map do |listing|
      listing.reservations
    end.flatten.map do |reservation|
      reservation.guest_id
    end.map do |guest_id|
      User.find_by_id(guest_id)
    end.map do |guest|
      guest.reviews
    end.flatten!
  end

end
