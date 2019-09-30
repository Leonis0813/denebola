# coding: utf-8

require 'spec_helper'

describe Feature, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        blank: [0],
        distance_diff: [0.0],
        entry_times: [0],
        grade: %w[G1 G2 G3 G J.G1 J.G2 J.G3 L OP N],
        horse_average_prize_money: [0.0],
        jockey_average_prize_money: [0.0],
        jockey_win_rate: [0, 1.0],
        jockey_win_rate_last_four_races: [0, 1.0],
        last_race_order: [0],
        month: (1..12).to_a,
        rate_within_third: [0, 1.0],
        second_last_race_order: [0],
        weight_per: [1, 1.0],
        win_times: [0],
        won: [true, false],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        blank: [-1, 0.0],
        distance_diff: [-1.0],
        entry_times: [-1, 0.0],
        grade: ['invalid'],
        horse_average_prize_money: [-1.0],
        jockey_average_prize_money: [-1.0],
        jockey_win_rate: [-0.1, 1.1],
        jockey_win_rate_last_four_races: [-0.1, 1.1],
        last_race_order: [-1, 1.0],
        month: [0, 13, 1.0],
        rate_within_third: [-0.1, 1.1],
        second_last_race_order: [-1, 1.0],
        weight_per: [0],
        win_times: [-1, 1.0],
      }
      absent_keys = invalid_attribute.keys - %i[grade won]
      it_behaves_like '必須パラメーターがない場合のテスト', absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end
end
