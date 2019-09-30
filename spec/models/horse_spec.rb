# coding: utf-8

require 'spec_helper'

describe Horse, type: :model do
  shared_context 'テストデータ作成' do
    include_context 'トランザクション作成'

    before(:all) do
      @horse = create(:horse)
      (1..5).each do |i|
        start_time = "2000-01-#{format('%02d', i)} 00:00:00"
        race = create(:race, race_id: i.to_s * 8, start_time: start_time)
        race.entries.first.update!(order: i.to_s, prize_money: i, horse_id: @horse.id)
      end
    end
  end

  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        horse_id: %w[0],
        running_style: %w[逃げ 先行 差し 追込],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        horse_id: ['invalid'],
        running_style: ['invalid'],
      }
      it_behaves_like '必須パラメーターがない場合のテスト', invalid_attribute.keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end

  describe '#average_prize_money' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '2.0を返すこと' do
        is_asserted_by { @horse.average_prize_money('2000-01-03 00:00:00') == 2.0 }
      end
    end
  end

  describe '#entry_times' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '3を返すこと' do
        is_asserted_by { @horse.entry_times('2000-01-03 00:00:00') == 3 }
      end
    end
  end

  describe '#last_race_order' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '2を返すこと' do
        is_asserted_by { @horse.last_race_order('2000-01-03 00:00:00') == 2 }
      end
    end
  end

  describe '#rate_within_third' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '1.0を返すこと' do
        is_asserted_by { @horse.rate_within_third('2000-01-03 00:00:00') == 1.0 }
      end
    end
  end

  describe '#second_last_race_order' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '1を返すこと' do
        is_asserted_by { @horse.second_last_race_order('2000-01-03 00:00:00') == 1 }
      end
    end
  end

  describe '#win_times' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '1を返すこと' do
        is_asserted_by { @horse.win_times('2000-01-03 00:00:00') == 1 }
      end
    end
  end

  describe '#results_before' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '3エントリー分を返すこと' do
        is_asserted_by { @horse.results_before('2000-01-03 00:00:00').size == 3 }
      end
    end
  end
end
