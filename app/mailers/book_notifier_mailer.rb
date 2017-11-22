class BookNotifierMailer < ApplicationMailer

  def book_return_remind(book)
    @book = book
    @reservation = book.reservations.find_by(status: "TAKEN")  
    @borrower = @reservation.user

    mail to: @borrower.email, subject: "\"#{@book.title}\" Your reservation will expire soon."
  end

  def book_reserved_return(book)
    @book = book      
    @reserver = @book.next_in_queue.user # jest takie słowo?
    
    mail to: @reserver.email, subject: "\"#{@book.title}\" will be available soon."
  end

end
