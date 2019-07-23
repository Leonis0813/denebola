# coding: utf-8

class Payoff < ActiveRecord::Base
  BETTING_TICKET_LIST = %w[単勝 複勝 枠連 馬連 ワイド 馬単 三連複 三連単].freeze

  belongs_to :race

  validates :betting_ticket, :odds,
            presence: {message: 'absent'}
  validates :betting_ticket,
            inclusion: {in: BETTING_TICKET_LIST, message: 'invalid'}
  validates :odds,
            numericality: {greater_than: 1, message: 'invalid'}
end
