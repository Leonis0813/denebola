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

      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        age: [0, 1.0],
        burden_weight: [0],
        final_600m_time: [0],
        number: [0, 1.0],
        order: ['invalid'],
        prize_money: [-1, 0.0],
        sex: ['invalid'],
        weight: [0],
      }
      absent_keys = invalid_attribute.keys - %i[final_600m_time prize_money weight]
      it_behaves_like '必須パラメーターがない場合のテスト', absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
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
            @entry = build(:entry, burden_weight: burden_weight, weight: weight)
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
        before(:all) { @entry = build(:entry, order: '1') }

        it 'trueを返すこと' do
          is_asserted_by { @entry.won }
        end
      end

      %w[2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 除 中 取 失].each do |order|
        context "orderが#{order}の場合" do
          before(:all) { @entry = build(:entry, order: order) }

          it 'falseを返すこと' do
            is_asserted_by { not @entry.won }
          end
        end
      end
    end
  end

  describe '.create_or_update!' do
    describe '正常系' do
      it_behaves_like '.create_or_update!: データが既に存在する場合のテスト',
                      {'age' => 4},
                      %i[race_id number]
      it_behaves_like '.create_or_update!: データが存在しない場合のテスト'
    end
  end

  describe '.log_attribute' do
    describe '正常系' do
      it_behaves_like '.log_attribute: 返り値が正しいこと'
    end
  end
end
