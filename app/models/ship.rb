class Ship < ActiveRecord::Base
  belongs_to :board
  belongs_to :square

  validates_presence_of :board
  validates :type, :inclusion => { :in => ["aircraft carrier", "battleship", "submarine", 
                                           "destroyer", "patrol boat"] }

  validates :state, :inclusion => { :in => ["unset", "set", "hit", "sunk"] }
end
