# 2.8.2 (2020/03/02)
- [UPDATE] gems

# 2.8.1 (2019/12/02)
- [UPDATE] ruby version to 2.6.3

# 2.8.0 (2019/11/29)
- [UPDATE] script to add option for operation
- [UPDATE] gems

# 2.7.0 (2019/11/19)
- [ADD] new race attribute
- [UPDATE] gems

# 2.6.2 (2019/09/23)
- [FIX] extraction script
- [UPDATE] index on entries table

# 2.6.1 (2019/08/03)
- [UPDATE] ruby version to 2.5.5

# 2.6.0 (2019/07/28)
- [UPDATE] script to extract jockey

# 2.5.0 (2019/07/26)
- [UPDATE] script to extract payoff

# 2.4.11 (2019/07/19)
- [FIX] extraction order
- [UPDATE] gems

# 2.4.10 (2019/06/30)
- [UPDATE] gems

# 2.4.9 (2019/06/17)
- [FIX] race validation

# 2.4.8 (2019/06/15)
- [REFACTOR] collection util
- [UPDATE] scripts to raise validation error
- [UPDATE] gems

# 2.4.7 (2019/05/26)
- [FIX] aggregation to change integer to string for entries

# 2.4.6 (2019/05/24)
- [ADD] index to races and entries table
- [UPDATE] horse model to cache results before entry time
- [UPDATE] config to output sql
- [UPDATE] prime_money not to set null
- [FIX] aggregation not to search null weight

# 2.4.5 (2019/05/23)
- [UPDATE] schema of races and features table

# 2.4.4 (2019/05/22)
- [ADD] element to order and grade list
- [FIX] mysql duplicate error

# 2.4.3 (2019/05/20)
- [ADD] validation to race, entry, horse and feature
- [FIX] table schema

# 2.4.2 (2019/05/19)
- [FIX] grade extraction error
- [UPDATE] default of grade in features table
- [UPDATE] features table schema to change order to won
- [REFACTOR] aggregation script
- [FIX] feature values by entry time

# 2.4.1 (2019/05/18)
- [FIX] encoding error for race and horse

# 2.4.0 (2019/05/17)
- [ADD] new entry and horse attributes
- [ADD] the following new features
  - average_prize_money
  - blank
  - distance_diff
  - entry_times
  - last_race_final_600m_time
  - last_race_order
  - rate_within_third
  - running_style
  - second_last_race_order
  - win_times
- [UPDATE] gems

# 2.3.2 (2019/05/04)
- [FIX] coding style
- [UPDATE] gems

# 2.3.1 (2019/05/02)
- [UPDATE] ruby version to 2.4.4

# 2.3.0 (2019/04/21)
- [ADD] new horse attributes
- [ADD] horse features to features table

# 2.2.0 (2019/04/15)
- [ADD] race_id attribute to races table
- [REFACTOR] logger
- [ADD] gem for HTTP client
- [UPDATE] collecting script to remove empty files

# 2.1.2 (2019/04/11)
- [UPDATE] gems

# 2.1.1 (2019/03/24)
- [UPDATE] gems

# 2.1.0 (2019/03/16)
- [ADD] script to extract race info

# 2.0.0 (2019/03/13)
- [ADD] feature to collect horses

# 1.0.10 (2019/03/02)
- [UPDATE] ruby version to 2.3.7
- [UPDATE] gems
- [FIX] migration task

# 1.0.9 (2019/02/09)
- [UPDATE] parser to use Nokogiri
- [FIX] url to get race data
- [ADD] month, sex and weight_per features

# 1.0.8 (2019/01/31)
- [UPDATE] gems

# 1.0.7 (2019/01/03)
- [UPDATE] gems

# 1.0.6 (2018/12/23)
- [UPDATE] gems

# 1.0.5 (2018/12/22)
- [UPDATE] gems

# 1.0.4 (2018/11/15)
- [FIX] html parse error

# 1.0.3 (2018/09/14)
- [UPDATE] for effective aggregation

# 1.0.2 (2018/09/01)
- [FIX] bug for collecting

# 1.0.1 (2018/08/13)
- [ADD] logger to aggregate.rb
- [UPDATE] logger to output stdout

# 1.0.0 (2018/08/11)
- [NEW] create app
