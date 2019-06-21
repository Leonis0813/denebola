# coding: utf-8

require 'spec_helper'

describe 'aggregate' do
  include_context 'トランザクション作成'

  before(:all) do
    horse = create(:horse)
    5.times do |i|
      race = create(:race, race_id: (i + 1).to_s * 8, start_time: Time.now + i)
      race.entries.first.update!(horse_id: horse.id)
    end
    load "#{APPLICATION_ROOT}/aggregate.rb"
  end

  it '素性が作成されていること' do
    is_asserted_by { Feature.count == 5 }
  end

  context '既に同じ素性が存在する場合' do
    before(:all) do
      @feature_size_before = Feature.count
      load "#{APPLICATION_ROOT}/aggregate.rb"
    end

    it '素性が新たに作成されていないこと' do
      is_asserted_by { Feature.count == @feature_size_before }
    end
  end
end
