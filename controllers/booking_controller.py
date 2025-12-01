from bottle import Bottle, request
from .base_controller import BaseController
from services.booking_service import BookingService
from models.stay import StayModel
from utils import login_required


class BookingController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.booking_service = BookingService()
        self.stay_model = StayModel()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/bookings', method='GET', callback=self.list_bookings)
        self.app.route('/bookings/add/<stay_id:int>', method=['GET', 'POST'], callback=login_required(self.add_booking))
        self.app.route('/bookings/edit/<booking_id:int>', method=['GET', 'POST'], callback=login_required(self.edit_booking))
        self.app.route('/bookings/delete/<booking_id:int>', method='POST', callback=self.delete_booking)

    def list_bookings(self):
        bookings = self.booking_service.get_all()
        stays = self.stay_model.get_all()
        stay_by_id = {s.id: s for s in stays}
        return self.render('bookings', bookings=bookings, stay_by_id=stay_by_id)

    def add_booking(self, stay_id):
        if request.method == 'GET':
            stay = self.stay_model.get_by_id(stay_id)
            return self.render(
                'booking_form',
                booking=None,
                stay_id=stay_id,
                stay=stay,
                action=f"/bookings/add/{stay_id}"
            )
        else:
            guest_id = int(request.forms.get('guest_id') or 1)
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
            self.redirect('/bookings')

    def delete_booking(self, booking_id):
        self.booking_service.delete_booking(booking_id)
        self.redirect('/bookings')


booking_routes = Bottle()
booking_controller = BookingController(booking_routes)
