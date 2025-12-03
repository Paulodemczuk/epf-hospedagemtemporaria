from bottle import Bottle, request
from .base_controller import BaseController
from services.booking_service import BookingService
from models.stay import StayModel
from utils import get_current_user, login_required, get_current_user_id
from models.user import UserModel



class BookingController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.booking_service = BookingService()
        self.stay_model = StayModel()
        self.user_model = UserModel()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/bookings', method='GET', callback=login_required(self.list_bookings))
        self.app.route('/bookings/add/<stay_id:int>', method=['GET', 'POST'], callback=login_required(self.add_booking))
        self.app.route('/bookings/edit/<booking_id:int>', method=['GET', 'POST'], callback=login_required(self.edit_booking))
        self.app.route('/bookings/delete/<booking_id:int>', method='POST', callback=self.delete_booking)
        self.app.route('/bookings/checkout', method='POST', callback=login_required(self.checkout))
        self.app.route('/bookings/confirm', method='POST', callback=login_required(self.confirm_booking))

    def list_bookings(self):
        user_id = get_current_user_id()
        bookings = self.booking_service.get_by_user(user_id)

        stays = self.stay_model.get_all()
        stay_by_id = {s.id: s for s in stays}
        user = self.user_model.get_by_id(user_id)


        return self.render('bookings', bookings=bookings, stay_by_id=stay_by_id, user=user)

    def add_booking(self, stay_id):
        if request.method == 'GET':
            stay = self.stay_model.get_by_id(stay_id)
            return self.render(
                'booking_form',
                booking=None,
                stay_id=stay_id,
                stay=stay,
                action=f"/bookings/checkout"
            )
        
        else:
            guest_id = get_current_user_id()
            result = self.booking_service.save(stay_id, guest_id)
            if isinstance(result, str):
                return result
            self.redirect('/bookings')

    def edit_booking(self, booking_id):
        booking = self.booking_service.get_by_id(booking_id)
        if not booking:
            return "Reserva não encontrada"

        if request.method == 'GET':
            stay = self.stay_model.get_by_id(booking.stay_id)
            return self.render(
                'booking_form',
                booking=booking,
                stay_id=booking.stay_id,
                stay=stay,
                action=f"/bookings/edit/{booking_id}"
            )
        else:
            self.booking_service.edit_booking(booking)
        
            current = get_current_user()
            if current and getattr(current, 'role', 'user') == 'admin':
                self.redirect('/admin/bookings')
            else:
                self.redirect('/bookings')

    def delete_booking(self, booking_id):
        self.booking_service.delete_booking(booking_id)
        self.redirect('/bookings')

    def checkout(self):
        stay_id = int(request.forms.get('stay_id') or request.query.get('stay_id'))
        check_in = request.forms.get('check_in')
        check_out = request.forms.get('check_out')
        try:
            guests_count = int(request.forms.get('guests_count') or 1)
        except ValueError:
            guests_count = 1

        guest_id = get_current_user_id()
        summary = self.booking_service.get_booking_summary(stay_id, check_in, check_out, guests_count, guest_id)
        
        if not summary or 'error' in summary:
            msg = summary.get('error') if summary else "Erro ao processar datas."
            
            msg_url = msg.replace(" ", "+")
            
            return self.redirect(f'/bookings/add/{stay_id}?error={msg_url}')

        return self.render('checkout', summary=summary, guests_count=guests_count)
    
    def confirm_booking(self):
        stay_id = int(request.forms.get('stay_id'))
        guest_id = get_current_user_id() 
        
        result = self.booking_service.save(stay_id, guest_id)
        
        if isinstance(result, str):
            return result
            
        self.redirect('/bookings?msg=Reserva+confirmada+com+sucesso!')


booking_routes = Bottle()
booking_controller = BookingController(booking_routes)
