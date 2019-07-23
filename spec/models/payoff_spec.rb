# coding: utf-8

require 'spec_helper'

describe Payoff, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        betting_ticket: %w[単勝 複勝 枠連 馬連 ワイド 馬単 三連複 三連単],
        odds: [1.1],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        betting_ticket: %w[invalid],
        odds: [1.0, nil],
      }
      absent_keys = invalid_attribute.keys - %i[odds]
      it_behaves_like '必須パラメーターがない場合のテスト', absent_keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end
end
