class Square < ActiveRecord::Base
  validates_presence_of :x, :y, :board
  validates :state, :inclusion => { :in => ["empty", "taken", "hit"] }

  belongs_to :board
  has_one :ship
end
