# coding: utf-8
class Entry < ActiveRecord::Base
  belongs_to :race
  has_one :result
end
