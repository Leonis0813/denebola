# coding: utf-8

require 'spec_helper'

describe Jockey, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        jockey_id: %w[0],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        jockey_id: ['invalid'],
      }
      it_behaves_like '必須パラメーターがない場合のテスト', invalid_attribute.keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end

  describe '#extra_attribute' do
    describe '正常系' do
      include_context 'トランザクション作成'

      before(:all) do
        @jockey = create(:jockey)
        (1..5).each do |i|
          start_time = "2000-01-#{format('%<day>02d', day: i)} 00:00:00"
          race = create(:race, race_id: i.to_s * 8, start_time: start_time)
          race.entries.first.update!(
            order: i.to_s,
            prize_money: i,
            jockey_id: @jockey.id,
          )
        end
      end

      it '正しい素性を返すこと' do
        is_asserted_by do
          @jockey.extra_attribute('2000-01-03 00:00:00') == {
            jockey_average_prize_money: 1.5,
            jockey_win_rate: 0.5,
            jockey_win_rate_last_four_races: 0.5,
          }
        end
      end
    end
  end
end
