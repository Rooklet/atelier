class ReservationsHandler < ApplicationController
  def initialize(user)
    @user = user
  end

  def take(book)
    return "Books is not available for reservation" unless book.can_be_taken?(user)
    if book.available_reservation.present?
      perform_expiration_worker(book.available_reservation)
      book.available_reservation.update_attributes(status: 'TAKEN')
    else
      perform_expiration_worker(book.reservations.create(user: user, status: 'TAKEN'))
    end
    ReservationMailer.reservation_info(book).deliver_now
  end

  def give_back(book)
    ActiveRecord::Base.transaction do
      book.reservations.find_by(status: 'TAKEN').update_attributes(status: 'RETURNED')
      book.next_in_queue.update_attributes(status: 'AVAILABLE') if book.next_in_queue.present?
    end
  end

  def reserve(book)
    return unless book.can_reserve?(user)
    book.reservations.create(user: user, status: 'RESERVED')
  end

  def cancel_reservation(book)
    book.reservations.where(user: user, status: 'RESERVED').order(created_at: :asc).first.update_attributes(status: 'CANCELED')
  end


  private

  attr_reader :user

  def perform_expiration_worker(reservation)
    ::BookReservationExpireWorker.perform_at(reservation.expires_at-2.day, reservation.book_id)
  end

  def next_in_queue(book)
    book.reservations.where(status: 'RESERVED').order(created_at: :asc).first
  end
end