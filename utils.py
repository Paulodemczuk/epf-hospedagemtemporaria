import hashlib
from bottle import redirect,request
from functools import wraps
from config import Config

def to_hash(input):
    return hashlib.sha256(input.encode('utf-8')).hexdigest()

def login_required(func):
    @wraps(func)
    def wrapper(*arg, **kwargs):
        user_id = request.get_cookie("user_session", secret=Config.SECRET_KEY)
        if not user_id:
            redirect('/login?error=Voce+precisa+estar+logado+para+realizar+essa+acao')
        
        return func(*arg,**kwargs)
    return wrapper

def get_current_user_id():
    user_id_cookie = request.get_cookie("user_session", secret=Config.SECRET_KEY)
    return int(user_id_cookie)
