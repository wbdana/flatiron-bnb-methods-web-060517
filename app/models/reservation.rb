class Reservation < ActiveRecord::Base
  validates :checkin, presence: true
  validates :checkout, presence: true
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review
  validate :no_res_on_own
  validate :available
  validate :misc_check_one
  validate :misc_check_two
  # validate :available_at_checkin
  # validate :available_at_checkout

  def duration
    self.checkout - self.checkin
  end

  def total_price
    night = self.listing.price
    night * self.duration
  end

  def no_res_on_own
    if self.listing.host_id == self.guest_id
      errors.add(:guest_id, "Guest is host")
    end
  end

  def available
    if self.checkin && self.checkout
      self.listing.reservations.find do |res|
        self.checkin <= res.checkout && self.checkout >= res.checkin
      end.nil? ? true : errors.add(:available, "Listing is unavailable at this time")
    end
  end

  def misc_check_one
    if self.checkin && self.checkout
      if self.checkin < self.checkout
        true
      else
        errors.add(:misc_check_one, "Checking out so soon? Like, before checkin?")
      end
    end
  end

  def misc_check_two
    if self.checkin && self.checkout
      !self.checkin == self.checkout
    end
  end


  # def available_at_checkin
  #   checkins = self.listing.reservations.map{|res| res.checkin}
  #   map = checkins.map{|ch| ch <= checkin ? 1 : 0 }
  #   if map.include?(1)
  #     errors.add(:checkin, "Unavailable at checkin")
  #   end
  # end


    # checkins.inject(self.checkin){|}

  #   ins = self.listing.reservations.map{|res| res.checkin}.first
  #   # binding.pry
  #   if ins <= self.checkin
  #     errors.add(:checkin, "Unavailable at checkin")
  #   end
  #   # binding.pry
  # end

  # def available
  #   unless available_at_checkin && available_at_checkout
  #     errors.add(:listing_id, "Invalid checkin or checkout")
  #   end
  # end
  #
  # def available_at_checkin
  #   # binding.pry
  #   if !self.listing.reservations.map{|res| res.checkin}.include?(self.checkin)
  #     errors.add(:listing_id, "Invalid checkin")
  #   end
  # end
  #
  # def available_at_checkout
  #   if !self.listing.reservaitons.map{|res| res.checkout}.include?(self.checkout)
  #     errors.add(:listing_id, "Invalid checkout")
  #   end
  # end

  #
  #
  # def available_at_checkin
  #   # binding.pry
  #   if self.listing.reservations.map{|res| res.checkin}.include?(self.checkin)
  #     errors.add(:listing_id, "Not available at checkin")
  #   end
  # end
  #
  # def available_at_checkout
  #   if self.listing.reservations.map{|res| res.checkout}.include?(self.checkout)
  #     errors.add(:listing_id, "Not available at checkout")
  #   end
  # end

end
