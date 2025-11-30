from typing import List, Optional
from datetime import datetime
from bottle import request
from models.booking import BookingModel, Booking
from models.stay import StayModel


class BookingService:
    def __init__(self):
        self.model = BookingModel()
        self.stay_model = StayModel()

    def get_all(self) -> List[Booking]:
        return self.model.get_all()

    def get_by_id(self, booking_id: int) -> Optional[Booking]:
        return self.model.get_by_id(booking_id)

    def _next_id(self) -> int:
        bookings = self.model.get_all()
        if not bookings:
            return 1
        return max(b.id for b in bookings) + 1

    def _calc_total_price(self, stay_id: int, check_in: str, check_out: str) -> float:
        stay = self.stay_model.get_by_id(stay_id)
        if not stay:
            return 0.0

        dt_in = datetime.strptime(check_in, "%d-%m-%Y")
        dt_out = datetime.strptime(check_out, "%d-%m-%Y")
        nights = (dt_out - dt_in).days
        nights = max(nights, 1)
        return stay.price_per_night * nights

    def save(self, stay_id: int, guest_id: int):
        form = request.forms
        check_in = form.get('check_in')
        check_out = form.get('check_out')

        total = self._calc_total_price(stay_id, check_in, check_out)

        booking = Booking(
            id=self._next_id(),
            stay_id=stay_id,
            guest_id=guest_id,
            check_in=check_in,
            check_out=check_out,
            total_price=total,
            status="confirmed"
        )
        self.model.add_booking(booking)

    def edit_booking(self, booking: Booking):
        form = request.forms
        booking.check_in = form.get('check_in')
        booking.check_out = form.get('check_out')
        booking.total_price = self._calc_total_price(
            booking.stay_id,
            booking.check_in,
            booking.check_out
        )
        booking.status = form.get('status') or booking.status
        self.model.update_booking(booking)

    def delete_booking(self, booking_id: int):
        self.model.delete_booking(booking_id)
