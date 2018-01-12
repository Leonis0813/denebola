# coding: utf-8
require_relative 'collect/fetch'

from = ARGV[0] ? Date.parse(ARGV[0]) : (Date.today - 7)
to = ARGV[1] ? Date.parse(ARGV[1]) : Date.today

(from..to).each do |date|
  fetch(:race_list, date.strftime('%Y%m%d')).each do |race_id|
    race = fetch(:race, race_id)
    insert(:race, race)
    race.entries.each {|entry| insert(entry) }
    race.results.each {|result| insert(entry.result) }
  end
end
