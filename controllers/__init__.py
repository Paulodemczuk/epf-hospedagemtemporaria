from bottle import Bottle
from controllers.user_controller import user_routes
from controllers.stay_controller import stay_routes
from controllers.booking_controller import booking_routes
from controllers.review_controller import review_routes
from controllers.feature_controller import feature_routes
from controllers.favorite_controller import favorite_routes
from controllers.login_controller import login_routes


def init_controllers(app: Bottle):
    app.merge(user_routes)
    app.merge(login_routes)
    app.mount('/', user_routes)
    app.mount('/', stay_routes)
    app.mount('/', booking_routes)
    app.mount('/', review_routes)
    app.mount('/', feature_routes)
    app.mount('/', favorite_routes)
