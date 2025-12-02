from bottle import Bottle, request, response, redirect
from .base_controller import BaseController
from services.auth_service import AuthService
from config import Config

class LoginController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.auth_service = AuthService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/login', method=['GET', 'POST'], callback=self.login)
        self.app.route('/logout', method='GET', callback=self.logout)

    def login(self):
        if request.method == 'GET':
            return self.render('login_form')
        
        email = request.forms.get('email')
        password = request.forms.get('password')

        user = self.auth_service.login(email, password)

        if user:
            response.set_cookie("user_session", str(user.id),secret=Config.SECRET_KEY, path='/')
            if getattr(user, "role", "user") == "admin":
                redirect('/admin')
            else:
                redirect('/stays')
        else:
            return self.render('login_form', error="Email ou senha inválidos")

    def logout(self):
        response.delete_cookie("user_session", path='/')
        redirect('/login')

login_routes = Bottle()
login_controller = LoginController(login_routes)