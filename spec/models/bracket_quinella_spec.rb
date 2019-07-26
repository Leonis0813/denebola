# coding: utf-8

require 'spec_helper'

describe BracketQuinella, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        odds: [1.0],
        favorite: [1],
        bracket_number1: [1],
        bracket_number2: [1],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        odds: [0.9, nil],
        favorite: [0, nil],
        bracket_number1: [0, nil],
        bracket_number2: [0, nil],
      }
      it_behaves_like '必須パラメーターがない場合のテスト', invalid_attribute.keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end
end
