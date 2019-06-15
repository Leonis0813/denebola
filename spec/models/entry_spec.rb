# coding: utf-8

require 'spec_helper'

describe Entry, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        age: [1],
        burden_weight: [1, 1.0],
        final_600m_time: [1, 1.0, nil],
        number: [1],
        order: %w[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 除 中 取 失],
        prize_money: [0, nil],
        sex: %w[牝 牡 セ],
        weight: [1, 1.0, nil],
      }

      test_cases = CommonHelper.generate_test_case(valid_attribute).select do |attribute|
        attribute.keys.sort == valid_attribute.keys.sort
      end

      test_cases.each do |attribute|
        it "#{attribute.keys.join(',')}を指定した場合、エラーにならないこと" do
          entry = Entry.new(attribute)
          entry.validate
          is_asserted_by { entry.errors.empty? }
        end
      end
    end

    describe '異常系' do
      invalid_attribute = {
        age: ['invalid', 0, 1.0, nil],
        burden_weight: ['invalid', 0, nil],
        final_600m_time: ['invalid', 0],
        number: ['invalid', 0, 1.0, nil],
        order: ['invalid', 0, 1.0, nil],
        prize_money: ['invalid', -1, 0.0],
        sex: ['invalid', 0, 1.0, nil],
        weight: ['invalid', 0],
      }

      test_cases = CommonHelper.generate_test_case(invalid_attribute)
      test_cases.sample(test_cases.size / 2).each do |attribute|
        it "#{attribute}を指定した場合、エラーになること" do
          entry = Entry.new(attribute)
          entry.validate
          is_asserted_by { entry.errors.present? }

          allow_nil = %i[final_600m_time weight prize_money]
          (invalid_attribute.keys - attribute.keys - allow_nil).each do |absent_key|
            is_asserted_by { entry.errors.messages[absent_key].include?('absent') }
          end

          attribute.keys.each do |invalid_key|
            is_asserted_by { entry.errors.messages[invalid_key].include?('invalid') }
          end
        end
      end
    end
  end

  describe '#weight_per' do
    describe '正常系' do
      [
        [0, 0, 0.0],
        [0, 400, 0.0],
        [50, 0, 0.0],
        [0, nil, 0.0],
        [50, nil, 0.0],
        [50, 400, 0.125],
      ].each do |burden_weight, weight, weight_per|
        context "burden_weight: #{burden_weight}, weight:#{weight}の場合" do
          before(:all) do
            @entry = Entry.new(burden_weight: burden_weight, weight: weight)
          end

          it "#{weight_per}を返すこと" do
            is_asserted_by { @entry.weight_per == weight_per }
          end
        end
      end
    end
  end

  describe '#won' do
    describe '正常系' do
      context 'orderが1の場合' do
        before(:all) { @entry = Entry.new(order: '1') }

        it 'trueを返すこと' do
          is_asserted_by { @entry.won }
        end
      end

      %w[2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 除 中 取 失].each do |order|
        context "orderが#{order}の場合" do
          before(:all) { @entry = Entry.new(order: order) }

          it 'falseを返すこと' do
            is_asserted_by { not @entry.won }
          end
        end
      end
    end
  end
end
