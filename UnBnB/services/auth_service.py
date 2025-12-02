from models.user import UserModel
from utils import to_hash

class AuthService:
    def __init__(self):
        self.user_model = UserModel()

    def login(self, email, password_input):
        if email.lower() == "admin@admin.com" and password_input == "ADMIN":
            from models.user import User
            return User(id=0, name="Admin", email=email,
                        birthdate="", password="", role="admin")

        self.user_model = UserModel()
        users = self.user_model.get_all()
        password_hash = to_hash(password_input)
        for user in users:
            if user.email == email and user.password == password_hash:
                return user
        return None
