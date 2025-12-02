from typing import List, Optional
from datetime import datetime, date
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
    
    def get_by_user(self, user_id: int):
        bookings = self.model.get_all()
        return [b for b in bookings if b.guest_id == user_id]

    def _next_id(self) -> int:
        bookings = self.model.get_all()
        if not bookings:
            return 1
        return max(b.id for b in bookings) + 1

    def _calc_total_price(self, stay_id: int, check_in: str, check_out: str) -> float:
        stay = self.stay_model.get_by_id(stay_id)
        if not stay:
            return 0.0

        dt_in = datetime.strptime(check_in, "%Y-%m-%d")
        dt_out = datetime.strptime(check_out, "%Y-%m-%d")
        nights = (dt_out - dt_in).days
        nights = max(nights, 1)
        return stay.price_per_night * nights
    
    def get_booking_summary(self, stay_id: int, check_in: str, check_out: str, guest_count: int):
        stay = self.stay_model.get_by_id(stay_id)
        if not stay:
            return None
        
        if guest_count > stay.max_guests:
            return {"error": f"Esta hospedagem permite no maximo {stay.max_guests} pessoas."}
        
        if self._has_conflict(stay_id, check_in, check_out):
            return {"error": "Datas indisponiveis para este periodo."}
        
        try:
            dt_in = datetime.strptime(check_in, "%Y-%m-%d")
            dt_out = datetime.strptime(check_out, "%Y-%m-%d")
            if dt_in >= dt_out:
                return {"error": "Data de saida deve ser maior que a entrada."}
            
            today = datetime.now()
            if dt_in < today:
                 return {"error": "A data de entrada nao pode ser no passado."}
            
            nights = (dt_out - dt_in).days

        except ValueError:
            return {"error": "Formato de data invalido."}

        total = stay.price_per_night * nights

        return {
            'stay': stay,
            'check_in': check_in,
            'check_out': check_out,
            'nights': nights,
            'price_per_night': stay.price_per_night,
            'total': total,
            'guest_count': guest_count
        }

    def save(self, stay_id: int, guest_id: int):
        form = request.forms
        check_in = form.get('check_in')
        check_out = form.get('check_out')
        guest_count = int(form.get('guests_count') or 1)

        try: 
            dt_in = datetime.strptime(check_in, "%Y-%m-%d")
            dt_out = datetime.strptime(check_out, "%Y-%m-%d")
        except (TypeError, ValueError):
            return "Datas inválidas"
        
        if dt_in >= dt_out:
            return "Data de check-out deve ser após a data de check-in"
        
        today = date.today()
        if dt_in.date() <= today:
            return "Data de check-in deve ser futura"
        
        stay = self.stay_model.get_by_id(stay_id)
        if not stay:
            return "Stay não encontrada"
        
        if guest_count > stay.max_guests:
            return f"Número de hóspedes excede o máximo permitido (máximo {stay.max_guests})"

        if self._has_conflict(stay_id, check_in, check_out):
            return "Conflito de reserva para esse período"

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
        new_check_in = form.get('check_in')
        new_check_out = form.get('check_out')

        if self._has_conflict(booking.stay_id, new_check_in, new_check_out, ignore_booking_id=booking.id):
            return "Conflito de reserva para esse período"


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

    def _has_conflict(self, stay_id: int, check_in: str, check_out: str, ignore_booking_id: int | None = None) -> bool:
        dt_in = datetime.strptime(check_in, "%Y-%m-%d")
        dt_out = datetime.strptime(check_out, "%Y-%m-%d")

        for b in self.model.get_all():
            if b.stay_id != stay_id:
                continue
            if ignore_booking_id is not None and b.id == ignore_booking_id:
                continue

            other_in = datetime.strptime(b.check_in, "%Y-%m-%d")
            other_out = datetime.strptime(b.check_out, "%Y-%m-%d")

            if dt_in < other_out and other_in < dt_out:
                return True

        return False
    
    def delete_by_user(self, user_id: int):
        bookings = self.model.get_all()
        to_keep = [b for b in bookings if b.guest_id != user_id]
        self.model.bookings = to_keep
        self.model._save()