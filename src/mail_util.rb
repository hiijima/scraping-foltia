require 'mail'

class MailUtil
  def self.send_mail(csv_file)
    mail = Mail.new do
      from     ENV['FROM_MAIL']
      to       ENV['TO_MAIL']
      subject  '新作アニメが更新されています'
      body     ''
      add_file(filename: 'anime.csv', content: File.read(csv_file))
    end
    mail.charset = 'utf-8'
    mail.delivery_method(:smtp, {
      address: ENV['MAIL_SERVER'],
      port: 25,
      authentication: :plain,
      enable_starttls_auto: true
    })
    mail.deliver!
  end
end
