class Entry < ApplicationRecord
  belongs_to :tournament, inverse_of: :entries, counter_cache: true
  has_many :boards, -> { order(number: :asc) }, inverse_of: :entry, dependent: :delete_all
end
