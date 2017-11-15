class BookNotifierMailer < ApplicationMailer

  def book_return_remind(book)
    @reservation = book.reservations.find_by(status: "TAKEN")  
    @book = book
    @borrower = @reservation.user

    mail to: @borrower.email, subject: "Upływa termin zwrotu książki \"#{@book.title}\"."
  end

  def book_reserved_return(book)
    @book = book      
    @reserver = @book.next_in_queue.user # reserver?!
    mail to: @reserver.email, subject: "\"#{@book.title}\" niebawem wróci do wypożyczalni."
  end

end
