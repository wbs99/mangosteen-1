class UserMailer < ApplicationMailer
  def welcome_email(code)
    @code = code
    mail(to: "1134954328@qq.com", subject: "hi")
  end
end