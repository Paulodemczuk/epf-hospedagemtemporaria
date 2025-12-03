from typing import List, Optional
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import io
import base64
from datetime import datetime, date
from bottle import request
from models.booking import BookingModel, Booking
from models.stay import StayModel
from models.user import UserModel



class BookingService:
    def __init__(self):
        self.model = BookingModel()
        self.stay_model = StayModel()
        self.user_model = UserModel()

    def get_all(self) -> List[Booking]:
        self.model = BookingModel()
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
    
    def _calculate_price_details(self, stay, nights, guest_id):
        original_total = stay.price_per_night * nights
        discount = 0
        self.user_model = UserModel()
        user = self.user_model.get_by_id(guest_id)
        if user and user.is_premium:
            discount = original_total * 0.15

        final_total = original_total - discount
        
        return original_total, discount, final_total
    
    def get_booking_summary(self, stay_id: int, check_in: str, check_out: str, guest_count: int,guest_id: int):
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

        original, discount, final = self._calculate_price_details(stay, nights, guest_id)

        return {
            'stay': stay,
            'check_in': check_in,
            'check_out': check_out,
            'nights': nights,
            'price_per_night': stay.price_per_night,
            'original_total': original,
            'discount': discount,
            'total': final,
            'guest_count': guest_count
        }
    
    def get_monthly_earnings_chart(self):
        bookings = self.model.get_all()
        earnings = {}

        for b in bookings:
            if b.status == 'confirmed':
                month_key = b.check_in[:7] 
                current = earnings.get(month_key, 0.0)
                earnings[month_key] = current + b.total_price

        if not earnings:
            return None

        sorted_months = sorted(earnings.keys())
        values = [earnings[m] for m in sorted_months]

        plt.figure(figsize=(8, 4))

        bars = plt.bar(sorted_months, values, color='#2f1c6a', alpha=0.8)
        plt.title('Faturamento Mensal (R$)', fontsize=14, fontweight='bold', color='#333')
        plt.xlabel('Mês', fontsize=10)
        plt.ylabel('Total (R$)', fontsize=10)
        plt.grid(axis='y', linestyle='--', alpha=0.5)
        
        for bar in bars:
            height = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2., height,
                     f'R${height:.0f}',
                     ha='center', va='bottom', fontsize=9)

        plt.tight_layout()

        img_buffer = io.BytesIO()
        plt.savefig(img_buffer, format='png')
        img_buffer.seek(0)
        plt.close()

        img_b64 = base64.b64encode(img_buffer.getvalue()).decode('utf-8')

        return img_b64

    def save(self, stay_id: int, guest_id: int):
        form = request.forms
        check_in = form.get('check_in')
        check_out = form.get('check_out')
        guest_count = int(form.get('guests_count') or 1)

        try: 
            dt_in = datetime.strptime(check_in, "%Y-%m-%d")
            dt_out = datetime.strptime(check_out, "%Y-%m-%d")
            nights = (dt_out - dt_in).days
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

        _, _, final_price = self._calculate_price_details(stay, nights, guest_id)

        booking = Booking(
            id=self._next_id(),
            stay_id=stay_id,
            guest_id=guest_id,
            check_in=check_in,
            check_out=check_out,
            total_price=final_price,
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

        try:
            d1 = datetime.strptime(booking.check_in, "%Y-%m-%d")
            d2 = datetime.strptime(booking.check_out, "%Y-%m-%d")
            nights = (d2 - d1).days
        except ValueError:
            return "Datas inválidas"

        stay = self.stay_model.get_by_id(booking.stay_id)
        _, _, final_price = self._calculate_price_details(stay, nights, booking.guest_id)
        
        booking.total_price = final_price

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