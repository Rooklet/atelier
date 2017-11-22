namespace :reservation do
  desc "Lunch 'return_remind_mailer'"
  task lunch_return_remind_mailer: :environment do
    reservations = Reservation.all.where(status: 'TAKEN', expires_at: Date.tomorrow.all_day)
    reservations.each do |reservation|
      ::BookReservationExpireWorker.perform_async(reservation.book_id)
    end
  end
end