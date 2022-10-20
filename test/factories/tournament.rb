FactoryBot.define do
  factory :tournament do
    guid { SecureRandom.hex(10) }
  end
end
