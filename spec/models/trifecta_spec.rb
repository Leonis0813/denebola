# coding: utf-8

require 'spec_helper'

describe Trifecta, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        odds: [1.0],
        favorite: [1],
        first_place_number: [1],
        second_place_number: [1],
        third_place_number: [1],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        odds: [0.9],
        favorite: [0],
        first_place_number: [0],
        second_place_number: [0],
        third_place_number: [0],
      }
      it_behaves_like '必須パラメーターがない場合のテスト', invalid_attribute.keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end
end
