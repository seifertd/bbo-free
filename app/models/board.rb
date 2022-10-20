class Board < ApplicationRecord
  belongs_to :entry, inverse_of: :boards
end
