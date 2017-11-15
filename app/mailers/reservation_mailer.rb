class ReservationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation_mailer.reservation_info.subject
  #
  def reservation_info(user, book, email)
    @user = user
    @book = book

    mail(to: email, subject: "Reserved book: \"#{@book.title}\"")
  end
end
