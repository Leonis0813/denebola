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

      test_cases = CommonHelper.generate_test_case(valid_attribute).select do |attribute|
        attribute.keys.sort == valid_attribute.keys.sort
      end

      test_cases.each do |attribute|
        it "#{attribute.keys.join(',')}を指定した場合、エラーにならないこと" do
          horse = Horse.new(attribute)
          horse.validate
          is_asserted_by { horse.errors.empty? }
        end
      end
    end

    describe '異常系' do
      invalid_attribute = {
        horse_id: ['invalid', nil],
        running_style: ['invalid', 0, 1.0, nil],
      }

      test_cases = CommonHelper.generate_test_case(invalid_attribute)
      invalid_test_cases = test_cases.select do |attribute|
        attribute.keys.sort == invalid_attribute.keys.sort
      end
      invalid_test_cases.each do |attribute|
        it "#{attribute}を指定した場合、invalidエラーになること" do
          horse = build(:horse, attribute)
          horse.validate
          is_asserted_by { horse.errors.present? }

          attribute.keys.each do |invalid_key|
            is_asserted_by { horse.errors.messages[invalid_key].include?('invalid') }
          end
        end
      end

      invalid_attribute.keys.each do |absent_key|
        it "#{absent_key}がない場合、absentエラーになること" do
          attribute = build(:horse).attributes.except(absent_key.to_s)
          horse = Horse.new(attribute)
          horse.validate
          is_asserted_by { horse.errors.present? }
          is_asserted_by { horse.errors.messages[absent_key].include?('absent') }
        end
      end
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
