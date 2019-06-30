# coding: utf-8

FactoryBot.define do
  factory :horse do
    horse_id { '1' * 8 }
    running_style { '逃げ' }
  end
end
