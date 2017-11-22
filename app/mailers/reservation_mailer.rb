class ReservationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reservation_mailer.reservation_info.subject
  #
  def reservation_info(book)
    @book = book
    @reservation = book.reservations.find_by(status: "TAKEN")  
    @user = @reservation.user

    mail to: @user.email, subject: "Reserved book: \"#{@book.title}\""
  end
end
