# coding: utf-8

require 'spec_helper'

describe Horse, type: :model do
  shared_context 'テストデータ作成' do
    include_context 'トランザクション作成'

    before(:all) do
      @horse = create(:horse)
      (1..5).each do |i|
        start_time = "2000-01-#{format('%<day>02d', day: i)} 00:00:00"
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

  describe '#extra_attribute' do
    describe '正常系' do
      include_context 'テストデータ作成'

      it '正しい素性を返すこと' do
        is_asserted_by do
          @horse.extra_attribute('2000-01-03 00:00:00') == {
            blank: 1,
            entry_times: 2,
            horse_average_prize_money: 1.5,
            last_race_order: 2,
            rate_within_third: 1.0,
            second_last_race_order: 1,
            win_times: 1,
          }
        end
      end
    end
  end

  describe '.create_or_update!' do
    describe '正常系' do
      it_behaves_like '.create_or_update!: データが既に存在する場合のテスト',
                      {'running_style' => '先行'},
                      %i[horse_id]
      it_behaves_like '.create_or_update!: データが存在しない場合のテスト'
    end
  end

  describe '.log_attribute' do
    describe '正常系' do
      it_behaves_like '.log_attribute: 返り値が正しいこと'
    end
  end
end
