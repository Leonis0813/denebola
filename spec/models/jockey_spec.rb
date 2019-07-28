# coding: utf-8

require 'spec_helper'

describe Jockey, type: :model do
  describe '#validates' do
    describe '正常系' do
      valid_attribute = {
        jockey_id: %w[0],
      }
      it_behaves_like '正常な値を指定した場合のテスト', valid_attribute
    end

    describe '異常系' do
      invalid_attribute = {
        jockey_id: ['invalid', nil],
      }
      it_behaves_like '必須パラメーターがない場合のテスト', invalid_attribute.keys
      it_behaves_like '不正な値を指定した場合のテスト', invalid_attribute
    end
  end
end
