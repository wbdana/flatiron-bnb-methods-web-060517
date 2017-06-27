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
    else
      errors.add(:misc_check_two, "Same day in, same day out? We don't do that here.")
    end
  end

end
