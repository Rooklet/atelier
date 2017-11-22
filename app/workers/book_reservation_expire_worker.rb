class BookReservationExpireWorker
  include Sidekiq::Worker

  def perform(book_id)
    book = Book.find(book_id)
    if book.reservations.find_by(status: 'TAKEN')
      BookNotifierMailer.book_return_remind(book).deliver
      if book.next_in_queue
        BookNotifierMailer.book_reserved_return(book).deliver
      end
    end
  end
end