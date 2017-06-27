class Review < ActiveRecord::Base
  validates :rating, :description, presence: true
  validate :checkout_checker

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def checkout_checker
    if self.reservation_id == nil
      errors.add(:reservation_id, "Needs a reservation")
    elsif !reservation_accepted
      errors.add(:reservation_id, "Unaccepted reservation")
    elsif Date.today < self.reservation.checkout
      errors.add(:reservation_id, "Not yet checked out")
    end
  end

  def reservation_accepted
    self.reservation.status == "accepted"
  end

end
