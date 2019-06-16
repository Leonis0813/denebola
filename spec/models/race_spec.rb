# coding: utf-8

require 'spec_helper'

describe Race, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        direction: %w[左 右 直 障],
        distance: [1],
        grade: ['G1', 'G2', 'G3', 'G', 'J.G1', 'J.G2', 'J.G3', 'L', 'OP', nil],
        place: %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神],
        race_id: %w[0],
        round: [1],
        track: %w[芝 ダート 障],
        weather: %w[晴 曇 小雨 雨 小雪 雪],
      }

      test_cases = CommonHelper.generate_test_case(valid_attribute).select do |attribute|
        attribute.keys.sort == valid_attribute.keys.sort
      end

      test_cases.each do |attribute|
        it "#{attribute.keys.join(',')}を指定した場合、エラーにならないこと" do
          race = Race.new(attribute)
          race.validate
          is_asserted_by { race.errors.empty? }
        end
      end
    end

    describe '異常系' do
      invalid_attribute = {
        direction: ['invalid', 1.0, 0, nil],
        distance: ['invalid', 1.0, 0, nil],
        grade: ['invalid', 1.0, 0],
        place: ['invalid', 1.0, 0, nil],
        race_id: ['invalid', nil],
        round: ['invalid', 1.0, 0, nil],
        track: ['invalid', 1.0, 0, nil],
        weather: ['invalid', 1.0, 0, nil],
      }

      test_cases = CommonHelper.generate_test_case(invalid_attribute)
      invalid_test_cases = test_cases.select do |attribute|
        attribute.keys.sort == invalid_attribute.keys.sort
      end
      invalid_test_cases.each do |attribute|
        it "#{attribute}を指定した場合、invalidエラーになること" do
          race = build(:race, attribute)
          race.validate
          is_asserted_by { race.errors.present? }

          attribute.keys.each do |invalid_key|
            is_asserted_by { race.errors.messages[invalid_key].include?('invalid') }
          end
        end
      end

      invalid_attribute.keys.each do |absent_key|
        it "#{absent_key}がない場合、absentエラーになること" do
          attribute = build(:race).attributes.except(absent_key)
          race = Race.new(attribute)
          race.validate
          is_asserted_by { race.errors.present? }
          is_asserted_by { race.errors.messages[absent_key].include?('absent') }
        end
      end
    end
  end

  describe '#month' do
    describe '正常系' do
      (1..12).each do |i|
        context "#{i}月の場合" do
          before(:all) do
            start_time = Time.parse("2000/#{format('%02d', i)}/01 00:00:00")
            @race = Race.new(start_time: start_time)
          end

          it "#{i}を返すこと" do
            is_asserted_by { @race.month == i }
          end
        end
      end
    end
  end
end
