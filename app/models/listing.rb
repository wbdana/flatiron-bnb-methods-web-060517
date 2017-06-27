class Listing < ActiveRecord::Base
  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood_id, presence: true
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  after_create :update_host_status_true
  before_destroy :update_host_status_false_if_no_listings

  def average_review_rating
    self.reviews.map{|rev| rev.rating}.inject(:+).round(2) / self.reviews.size.round(2)
  end

  private

  def update_host_status_true
    user = User.find_by_id(self.host_id)
    user.update(host: true)
  end

  def update_host_status_false_if_no_listings
    user = User.find_by_id(self.host_id)
    if user.listings.size - 1 == 0
      user.update(host: false)
    end
  end

end
