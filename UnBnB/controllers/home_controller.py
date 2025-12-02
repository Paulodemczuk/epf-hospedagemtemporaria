from bottle import Bottle, template, redirect
from utils import get_current_user_id

home_routes = Bottle()

@home_routes.route('/home', method='GET')
def home():
    return template('home')

@home_routes.route('/entrar', method='GET')
def entrar():
    user_id = get_current_user_id()
    if user_id is not None:
        return redirect('/stays')
    redirect('/login')
    
