from bottle import Bottle
from .base_controller import BaseController
from models.user import UserModel
from services.stay_service import StayService
from services.booking_service import BookingService
from utils import admin_required
from services.user_service import UserService



class AdminController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.user_model = UserModel()
        self.stay_service = StayService()
        self.booking_service = BookingService()
        self.user_service = UserService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/admin', method='GET',
                       callback=admin_required(self.dashboard))
        self.app.route('/admin/users', method='GET',
                       callback=admin_required(self.list_users))
        self.app.route('/admin/analytics', method='GET', callback=admin_required(self.analytics))
        self.app.route('/admin/stays', method='GET',
                       callback=admin_required(self.list_stays))
        self.app.route('/admin/bookings', method='GET',
                       callback=admin_required(self.list_bookings))
        self.app.route('/admin/users/delete/<user_id:int>', method='POST',
                       callback=admin_required(self.delete_user))
        self.app.route('/admin/stays/delete/<stay_id:int>', method='POST',
                       callback=admin_required(self.delete_stay))
        self.app.route('/admin/bookings/delete/<booking_id:int>', method='POST',
                       callback=admin_required(self.delete_booking))

    def dashboard(self):
        return self.render('admin_dashboard')

    def list_users(self):
        users = self.user_model.get_all()
        return self.render('admin_users', users=users)

    def list_stays(self):
        stays = self.stay_service.get_all()
        return self.render('admin_stays', stays=stays)

    def list_bookings(self):
        bookings = self.booking_service.get_all()
        users = self.user_model.get_all()
        users_by_id = {u.id: u for u in users}
        return self.render('admin_bookings', bookings=bookings, users_by_id=users_by_id)
    
    def analytics(self):
        chart_data = self.booking_service.get_monthly_earnings_chart()
        return self.render('admin_analytics', chart=chart_data)
    
    def delete_user(self, user_id):
        if user_id == 0:
            return "Não é permitido deletar o admin."
        self.user_service.delete_user(user_id)
        self.redirect('/admin/users')

    def delete_stay(self, stay_id):
        self.stay_service.delete_stay(stay_id)
        self.redirect('/admin/stays')

    def delete_booking(self, booking_id):
        self.booking_service.delete_booking(booking_id)
        self.redirect('/admin/bookings')


admin_routes = Bottle()
admin_controller = AdminController(admin_routes)
