class Review < ActiveRecord::Base
  validates :rating, :description, presence: true
  # validates_associated :reservation, acceptance: true
  validate :checkout_checker

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  def checkout_checker
    # binding.pry
    if self.reservation_id == nil
      errors.add(:reservation_id, "Needs a reservation")
    elsif !reservation_accepted
      errors.add(:reservation_id, "Unaccepted reservation")
    # elsif self.reservation.status == "accepted"
    #   errors.add(:reservation_id, "Unaccpted reservation")
    # elsif !Reservation.find_by_id(self.reservation_id).status == "accepted"
      # errors.add(:reservation_id, "Unaccepted reservation")
    elsif Date.today < self.reservation.checkout
      errors.add(:reservation_id, "Not yet checked out")
    end
  end

  def reservation_accepted
    self.reservation.status == "accepted"
  end

    # binding.pry
  #   self.reservation.checkout < Date.today if !self.reservation.nil?
  # end

end
