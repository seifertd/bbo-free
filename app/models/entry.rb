class Entry < ApplicationRecord
  belongs_to :tournament, inverse_of: :entries
  has_many :boards, -> { order(number: :asc) }, inverse_of: :entry
end
