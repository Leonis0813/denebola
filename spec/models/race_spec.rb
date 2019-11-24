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
      it_behaves_like '必須パラメーターがない場合のテスト', absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end

  describe '#month' do
    describe '正常系' do
      (1..12).each do |i|
        context "#{i}月のレースの場合" do
          before(:all) do
            time_string = "2000/#{format('%<month>02d', month: i)}/01 00:00:00"
            start_time = Time.parse(time_string)
            @race = build(:race, start_time: start_time)
          end

          it "#{i}を返すこと" do
            is_asserted_by { @race.month == i }
          end
        end
      end
    end
  end

  describe '.create_or_update!' do
    describe '正常系' do
      context 'データが既に存在する場合' do
        [
          ['create', {}],
          ['update', {'round' => 2}],
          ['upsert', {'round' => 2}],
        ].each do |operation, expected_attribute|
          context "operation: #{operation}の場合" do
            include_context 'トランザクション作成'
            before(:all) do
              ApplicationRecord.operation = operation
              race = create(:race)
              @before_count = Race.count
              @expected_race = race.attributes.merge(expected_attribute)
              @target_race = Race.create_or_update!(race_id: race.race_id, round: 2)
            end

            it '新しく作成されていないこと' do
              is_asserted_by { Race.count == @before_count }
            end

            it '登録済みデータの値が正しいこと' do
              is_asserted_by { @target_race.attributes == @expected_race }
            end
          end
        end
      end

      context 'データが存在しない場合' do
        [
          ['create', 1],
          ['update', 0],
          ['upsert', 1],
        ].each do |operation, additional_count|
          context "operation: #{operation}の場合" do
            include_context 'トランザクション作成'
            before(:all) do
              ApplicationRecord.operation = operation
              @before_count = Race.count
              Race.create_or_update!(build(:race).attributes)
            end

            it '登録されているデータの数が正しいこと' do
              is_asserted_by { Race.count == @before_count + additional_count }
            end
          end
        end
      end
    end
  end

  describe '.log_attribute' do
    describe '正常系' do
      %w[create update upsert].each do |operation|
        context "operation: #{operation}の場合" do
          expected = {action: operation, resource: 'race'}
          before(:all) { ApplicationRecord.operation = operation }

          it "#{expected}を返していること" do
            is_asserted_by { Race.log_attribute == expected }
          end
        end
      end
    end
  end
end
