class Board < ActiveRecord::Base
  has_many :squares
  has_many :ships
end
