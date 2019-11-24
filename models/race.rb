# coding: utf-8

require_relative 'application_record'

class Race < ApplicationRecord
  DIRECTION_LIST = %w[左 右 直 障].freeze
  GRADE_LIST = %w[G1 G2 G3 G J.G1 J.G2 J.G3 L OP].freeze
  PLACE_LIST = %w[中京 中山 京都 函館 小倉 新潟 札幌 東京 福島 阪神].freeze
  TRACK_LIST = %w[芝 ダート 障].freeze
  WEATHER_LIST = %w[晴 曇 小雨 雨 小雪 雪].freeze
  ONE_PATTERN_TICKET_LIST = %i[win bracket_quinella quinella exacta trio trifecta].freeze
  MULTI_PATTERNS_TICKET_LIST = %i[shows quinella_places].freeze

  has_many :entries
  has_one :win
  has_many :shows
  has_one :bracket_quinella
  has_one :quinella
  has_many :quinella_places
  has_one :exacta
  has_one :trio
  has_one :trifecta

  validates :distance, :direction, :place, :race_id, :race_name, :round, :track,
            :weather,
            presence: {message: 'absent'}
  validates :direction,
            inclusion: {in: DIRECTION_LIST, message: 'invalid'},
            allow_nil: true
  validates :distance, :round,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :grade,
            inclusion: {in: GRADE_LIST, message: 'invalid'},
            allow_nil: true
  validates :place,
            inclusion: {in: PLACE_LIST, message: 'invalid'},
            allow_nil: true
  validates :race_id,
            format: {with: /\A\d+\z/, message: 'invalid'},
            allow_nil: true
  validates :round,
            numericality: {only_integer: true, greater_than: 0, message: 'invalid'},
            allow_nil: true
  validates :track,
            inclusion: {in: TRACK_LIST, message: 'invalid'},
            allow_nil: true
  validates :weather,
            inclusion: {in: WEATHER_LIST, message: 'invalid'},
            allow_nil: true

  def self.create_or_update!(attribute)
    race = find_by(attribute.slice(:race_id))
    super(race, attribute)
  end

  def self.log_attribute
    super.merge(resource: 'race')
  end

  def month
    start_time.month
  end

  def create_or_update_payoff(attribute)
    attribute.slice(*ONE_PATTERN_TICKET_LIST).each do |betting_ticket, attr|
      ticket = send(betting_ticket)
      ticket.update!(attr) if ticket.present? and self.class.updatable?
      send("create_#{betting_ticket}") if ticket.nil? and self.class.creatable?
    end

    attribute.slice(*MULTI_PATTERNS_TICKET_LIST).each do |betting_ticket, attrs|
      attrs.each do |attr|
        send(betting_ticket).find_or_create_by!(attr)
      end
    end
  end
end
