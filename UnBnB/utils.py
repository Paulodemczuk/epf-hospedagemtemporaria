import hashlib
from bottle import redirect, request
from functools import wraps
from config import Config
from models.user import UserModel
from datetime import datetime


def to_hash(input):
    return hashlib.sha256(input.encode('utf-8')).hexdigest()


def login_required(func):
    @wraps(func)
    def wrapper(*arg, **kwargs):
        user_id = request.get_cookie("user_session", secret=Config.SECRET_KEY)
        if not user_id:
            redirect('/login?error=Voce+precisa+estar+logado+para+realizar+essa+acao')
        return func(*arg, **kwargs)
    return wrapper


def get_current_user_id():
    user_id_cookie = request.get_cookie("user_session", secret=Config.SECRET_KEY)
    if not user_id_cookie:
        return None
    try:
        return int(user_id_cookie)
    except (TypeError, ValueError):
        return None

def get_current_user():
    user_id_cookie = request.get_cookie("user_session", secret=Config.SECRET_KEY)
    if not user_id_cookie:
        return None
    try:
        user_id = int(user_id_cookie)
    except ValueError:
        return None
    
    if user_id == 0:
        from models.user import User
        return User(id=0, name="ADMIN", email="admin@admin.com", birthdate="", password="ADMIN", role="admin")

    user_model = UserModel()
    return user_model.get_by_id(user_id)

def admin_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        user = get_current_user()
        if not user or getattr(user, "role", "user") != "admin":
            redirect('/login?error=Voce+nao+tem+permissao+para+acessar+esta+area')
        return func(*args, **kwargs)
    return wrapper

def format_date(date_str):
    if not date_str:
        return ""
    try:
        dt = datetime.strptime(date_str, "%Y-%m-%d")
        return dt.strftime("%d/%m/%Y")
    except ValueError:
        return date_str