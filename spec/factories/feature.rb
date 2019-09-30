# coding: utf-8

FactoryBot.define do
  factory :feature do
    age { 3 }
    blank { 7 }
    burden_weight { 56 }
    direction { '左' }
    distance { 2000 }
    distance_diff { 0 }
    entry_times { 3 }
    grade { 'G1' }
    horse_average_prize_money { 2000000 }
    horse_id { '1' * 8 }
    jockey_average_prize_money { 2000000 }
    jockey_win_rate { 0.3 }
    jockey_win_rate_last_four_races { 0.1 }
    last_race_order { 4 }
    month { 5 }
    number { 1 }
    place { '中京' }
    race_id { '0' * 8 }
    rate_within_third { 0.1 }
    round { 1 }
    running_style { '逃げ' }
    second_last_race_order { 2 }
    sex { '牝' }
    track { '芝' }
    weather { '晴' }
    weight { 486 }
    weight_diff { 2 }
    weight_per { 0.15 }
    win_times { 1 }
    won { false }
  end
end
