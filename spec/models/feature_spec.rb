# coding: utf-8

require 'spec_helper'

describe Feature, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        average_prize_money: [0, 0.0],
        blank: [0],
        distance_diff: [0, 0.0],
        entry_times: [0],
        grade: ['G1', 'G2', 'G3', 'G', 'J.G1', 'J.G2', 'J.G3', 'L', 'OP', 'N', nil],
        last_race_order: [0],
        month: (1..12).to_a,
        rate_within_third: [0, 0.0],
        second_last_race_order: [0],
        weight_per: [1, 1.0],
        win_times: [0],
        won: [true, false],
      }

      test_cases = CommonHelper.generate_test_case(valid_attribute).select do |attribute|
        attribute.keys.sort == valid_attribute.keys.sort
      end

      test_cases.each do |attribute|
        it "#{attribute.keys.join(',')}を指定した場合、エラーにならないこと" do
          feature = create(:feature, attribute)
          feature.validate
          is_asserted_by { feature.errors.empty? }
        end
      end
    end

    describe '異常系', :wip do
      invalid_attribute = {
        average_prize_money: ['invalid', -1.0, nil],
        blank: ['invalid', -1, 1.0, nil],
        distance_diff: ['invalid', -1.0, nil],
        entry_times: ['invalid', -1, 1.0, nil],
        grade: ['invalid', 0, 1.0],
        last_race_order: ['invalid', -1, 1.0, nil],
        month: ['invalid', 0, 13, 1.0, nil],
        rate_within_third: ['invalid', -1.0, nil],
        second_last_race_order: ['invalid', -1, 1.0, nil],
        weight_per: ['invalid', 0, nil],
        win_times: ['invalid', -1, 1.0, nil],
        won: ['invalid', 0, 1.0, nil],
      }

      test_cases = CommonHelper.generate_test_case(invalid_attribute)
      invalid_test_cases = test_cases.select do |attribute|
        attribute.keys.sort == invalid_attribute.keys.sort
      end
      invalid_test_cases.each do |attribute|
        it "#{attribute}を指定した場合、エラーになること" do
          feature = Feature.new(attribute)
          feature.validate
          is_asserted_by { feature.errors.present? }

          attribute.keys.each do |invalid_key|
            is_asserted_by { feature.errors.messages[invalid_key].include?('invalid') }
          end
        end
      end

      invalid_attribute.keys.each do |absent_key|
        it "#{absent_key}がない場合、absentエラーになること" do
          attribute = build(:feature).attributes.except(absent_key)
          feature = Feature.new(attribute)
          feature.validate
          is_asserted_by { feature.errors.present? }
          is_asserted_by { feature.errors.messages[absent_key].include?('absent') }
        end
      end
    end
  end
end
