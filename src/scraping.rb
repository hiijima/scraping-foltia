require 'net/http'
require 'nokogiri'
require 'csv'
require 'time'
require './src/anime_program.rb'
require './src/mail_util.rb'

class Scraping
  def info_new_anime
    res = Net::HTTP.start(URI.parse("http://foltiahosts/").host) do |http|
      http.get('/animeprogram/index.php?view=np&filter=crp')
    end
    raise "foltiaサーバーへの接続エラー" unless res.code == '200'
    doc = Nokogiri::HTML.parse(res.body)
    anime_programs = doc.css('#newAnimeTable div table tr:not(:first-child)')

    grouping_by_title = {}
    anime_programs.select do |e|
      e['class'].nil? || e['class'].empty? || # 未登録
      e['class'] == 'planned' # 予約済み
    end.each do |program|
      channel = program.css('.station').text
      title = program.css('.title a').text
      /(\d{4}\/\d{1,2}\/\d{1,2})\((.)\).*(\d{2}:\d{2}).*/ =~ program.css('.date').text
      date, week = "#{$1} #{$3}", $2
      time = program.css('.time').text
      anime = AnimeProgram.new(channel, title, date, week, time, program['class'] == 'planned')
      grouping_by_title.key?(title) ? grouping_by_title[title] = [grouping_by_title[title], anime].flatten : grouping_by_title[title] = [anime]
    end
    unless grouping_by_title.empty?
      csv_file = "/tmp/anime_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
      CSV.open(csv_file, 'w') do |csv|
        csv << ['番組名', '録画済み？', '放送日時(最短)', '放送時間', 'チャンネル']
        grouping_by_title.each do |title, animes|
          planned_str = animes.any?(&:planned?) ? 'はい' : 'いいえ'
          channles = animes.map(&:channel).join('/')
          date_of_min = animes.min_by(&:date)
          csv << [title, planned_str, Time.parse(date_of_min.date).strftime("%Y/%m/%d(#{date_of_min.week}) %H:%M:%S"), animes[0].time, channles]
        end
      end
      ## メール送信
      MailUtil.send_mail(csv_file) && File.delete(csv_file)
    end
  end
end
