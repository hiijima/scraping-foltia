require './src/scraping.rb'

begin
  Scraping.new.info_new_anime
rescue StandardError => e
  puts "エラーが発生しました。#{e}"
  puts e.backtrace
end
