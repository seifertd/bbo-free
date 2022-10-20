FactoryBot.define do
  factory :board do
    number { 1 }
    played_at { DateTime.now }
    north { 'north' }
    south { 'south' }
    east { 'east' }
    west { 'west' }
    result { '7N+0' }
    points { rand(-1000..2800)}
    score { 50.0 }
    movie_url { 'movie_url' }
    lin_url { 'lin_url' }
    traveller_url { 'traveller_url' }
    lin_data { 'lin_data' }
  end
end
