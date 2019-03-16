# coding: utf-8
class Race < ActiveRecord::Base
  has_many :entries
end
