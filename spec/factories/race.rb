# coding: utf-8

FactoryBot.define do
  factory :race do
    direction { '左' }
    distance { 2000 }
    place { '中京' }
    race_id { '0' * 8 }
    race_name { 'レース名' }
    round { 1 }
    start_time { '2000-01-01 00:00:00' }
    track { '芝' }
    weather { '晴' }
    entries { [FactoryBot.create(:entry)] }
  end
end
