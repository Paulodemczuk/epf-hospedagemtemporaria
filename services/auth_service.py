from models.user import UserModel
from utils import to_hash

class AuthService:
    def __init__(self):
        self.user_model = UserModel()

    def login(self, email,password_input):
        users = self.user_model.get_all()
        password_hash = to_hash(password_input)
        for user in users:
            if user.email == email:
                if user.password == password_hash:
                    return user
        return None
