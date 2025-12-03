from bottle import Bottle
from .base_controller import BaseController
from services.user_service import UserService
from utils import login_required, get_current_user_id

class PremiumController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.user_service = UserService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/premium', method='GET', callback=self.premium_page)
        self.app.route('/premium/subscribe', method='POST', callback=login_required(self.subscribe))

    def premium_page(self):
        return self.render('premium_landing')

    def subscribe(self):
        self.user_service = UserService()
        user_id = get_current_user_id()
        self.user_service.toggle_premium(user_id)
        self.redirect('/premium?success=1')

premium_routes = Bottle()
premium_controller = PremiumController(premium_routes)