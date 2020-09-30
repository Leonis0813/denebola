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
        race_name: %w[レース名],
        round: [1],
        track: %w[芝 ダート 障],
        weather: %w[晴 曇 小雨 雨 小雪 雪],
      }
      include_context 'トランザクション作成'
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        direction: ['invalid'],
        distance: [0, 1.0],
        grade: ['invalid'],
        place: ['invalid'],
        race_id: ['invalid'],
        round: [0, 1.0],
        track: ['invalid'],
        weather: ['invalid'],
      }
      absent_keys = invalid_attribute.keys - %i[grade] + %i[race_name]
      include_context 'トランザクション作成'
      it_behaves_like '必須パラメーターがない場合のテスト', absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end

  describe '#extra_attribute' do
    describe '正常系' do
      (1..12).each do |i|
        context "#{i}月のレースの場合" do
          include_context 'トランザクション作成'
          before(:all) do
            time_string = "2000/#{format('%<month>02d', month: i)}/01 00:00:00"
            start_time = Time.parse(time_string)
            @race = build(:race, start_time: start_time)
          end

          it "#{i}を返すこと" do
            is_asserted_by { @race.extra_attribute == {month: i} }
          end
        end
      end
    end
  end

  describe '.create_or_update!' do
    describe '正常系' do
      it_behaves_like '.create_or_update!: データが既に存在する場合のテスト',
                      {'round' => 2},
                      %i[race_id]
      it_behaves_like '.create_or_update!: データが存在しない場合のテスト'
    end
  end

  describe '.log_attribute' do
    describe '正常系' do
      it_behaves_like '.log_attribute: 返り値が正しいこと'
    end
  end
end
