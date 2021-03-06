class UserMailer < ApplicationMailer
  def account_activation
    @user = user
    mail to: user.email, subject: t("mailer.subject")
  end

  def password_reset
    @greeting = t "mailer.user_mailer.password_reset"
    mail to: "to@example.org"
  end
end
