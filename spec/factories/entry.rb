# coding: utf-8

FactoryBot.define do
  factory :entry do
    age { 3 }
    burden_weight { 56 }
    final_600m_time { 10.4 }
    number { 1 }
    order { 1 }
    prize_money { 13500000 }
    sex { '牝' }
    weight { 486 }
    weight_diff { 2 }
    race { FactoryBot.build(:race_without_entry) }
  end

  factory :entry_without_race, class: Entry do
    age { 3 }
    burden_weight { 56 }
    final_600m_time { 10.4 }
    number { 1 }
    order { 1 }
    prize_money { 13500000 }
    sex { '牝' }
    weight { 486 }
    weight_diff { 2 }
  end
end
