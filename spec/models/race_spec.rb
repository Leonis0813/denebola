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
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
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
      absent_keys = invalid_attribute.keys - %i[grade]
      it_behaves_like '必須パラメーターがない場合のテスト', :race, absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', :race, invalid_attribute
    end
  end

  describe '#month' do
    describe '正常系' do
      (1..12).each do |i|
        context "#{i}月のレースの場合" do
          before(:all) do
            start_time = Time.parse("2000/#{format('%02d', i)}/01 00:00:00")
            @race = build(:race, start_time: start_time)
          end

          it "#{i}を返すこと" do
            is_asserted_by { @race.month == i }
          end
        end
      end
    end
  end
end
