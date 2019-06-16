# coding: utf-8

FactoryBot.define do
  factory :feature do
    age { 3 }
    average_prize_money { 2000000 }
    blank { 7 }
    burden_weight { 56 }
    direction { '左' }
    distance { 2000 }
    distance_diff { 0 }
    entry_times { 3 }
    grade { 'G1' }
    horse_id { '1' * 8 }
    last_race_order { 4 }
    month { 5 }
    number { 1 }
    place { '中京' }
    race_id { '0' * 8 }
    round { 1 }
    running_style { '逃げ' }
    sex { '牝' }
    track { '芝' }
    weather { '晴' }
    weight { 486 }
    weight_diff { 2 }
    weight_per { 0.15 }
    won { false }
  end
end
