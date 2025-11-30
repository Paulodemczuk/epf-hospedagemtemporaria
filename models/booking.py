import json
import os
from datetime import datetime

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


class Booking:
    def __init__(self, id, listing_id, guest_id, check_in, check_out, total_price, status="confirmed"):
        self.id = id
        self.listing_id = listing_id
        self.guest_id = guest_id
        self.check_in = check_in
        self.check_out = check_out
        self.total_price = float(total_price)
        self.status = status

    def __repr__(self):
        return (
            f"Booking(id={self.id}, listing_id={self.listing_id}, guest_id={self.guest_id}, "
            f"check_in='{self.check_in}', check_out='{self.check_out}', "
            f"total_price={self.total_price}, status='{self.status}')"
        )

    def to_dict(self):
        return {
            'id': self.id,
            'listing_id': self.listing_id,
            'guest_id': self.guest_id,
            'check_in': self.check_in,
            'check_out': self.check_out,
            'total_price': self.total_price,
            'status': self.status
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            listing_id=data['listing_id'],
            guest_id=data['guest_id'],
            check_in=data['check_in'],
            check_out=data['check_out'],
            total_price=data['total_price'],
            status=data.get('status', 'confirmed')
        )


class BookingModel:
    FILE_PATH = os.path.join(DATA_DIR, 'bookings.json')

    def __init__(self):
        self.bookings = self._load()

    def _load(self):
        if not os.path.exists(self.FILE_PATH):
            return []
        with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [Booking(**item) for item in data]

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([b.to_dict() for b in self.bookings], f, indent=4, ensure_ascii=False)

    def get_all(self):
        return self.bookings

    def get_by_id(self, booking_id: int):
        return next((b for b in self.bookings if b.id == booking_id), None)

    def add_booking(self, booking: Booking):
        self.bookings.append(booking)
        self._save()

    def update_booking(self, updated_booking: Booking):
        for i, booking in enumerate(self.bookings):
            if booking.id == updated_booking.id:
                self.bookings[i] = updated_booking
                self._save()
                break

    def delete_booking(self, booking_id: int):
        self.bookings = [b for b in self.bookings if b.id != booking_id]
        self._save()
