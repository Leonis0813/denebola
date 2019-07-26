# coding: utf-8

FactoryBot.define do
  factory :payoff do
    betting_ticket { '単勝' }
    odds { 1.1 }
  end
end
