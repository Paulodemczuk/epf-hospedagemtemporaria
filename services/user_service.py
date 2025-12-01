from bottle import request
from models.user import UserModel, User
from utils import to_hash
from services.booking_service import BookingService
from services.stay_service import StayService

class UserService:
    def __init__(self):
        self.user_model = UserModel()
        self.booking_service = BookingService()
        self.stay_service = StayService()


    def get_all(self):
        users = self.user_model.get_all()
        return users


    def save(self):
        last_id = max([u.id for u in self.user_model.get_all()], default=0)
        new_id = last_id + 1
        name = request.forms.get('name')
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')

        password_raw = request.forms.get('password')
        password_hash = to_hash(password_raw)

        user = User(id=new_id, name=name, email=email, birthdate=birthdate, password=password_hash)
        self.user_model.add_user(user)


    def get_by_id(self, user_id):
        return self.user_model.get_by_id(user_id)


    def edit_user(self, user):
        name = request.forms.get('name')
        email = request.forms.get('email')
        birthdate = request.forms.get('birthdate')
        password = request.forms.get('password')

        if password:
            from utils import to_hash
            user.password = to_hash(password)

        user.name = name
        user.email = email
        user.birthdate = birthdate

        self.user_model.update_user(user)


    def delete_user(self, user_id):
        self.booking_service.delete_by_user(user_id)
        self.stay_service.delete_by_host(user_id)
        self.user_model.delete_user(user_id)
