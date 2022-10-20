FactoryBot.define do
  factory :entry do
    player { 'foobar' }
    played_at { DateTime.now }
    score { 42 }
    rank { 1 }
  end
end
