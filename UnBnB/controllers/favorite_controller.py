from bottle import Bottle, request
from .base_controller import BaseController
from services.favorite_service import FavoriteService
from services.stay_service import StayService
from models.user import UserModel
from utils import get_current_user_id, login_required


class FavoriteController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.favorite_service = FavoriteService()
        self.stay_service = StayService()
        self.user_model = UserModel()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/favorites', method='GET', callback=login_required(self.list_favorites))
        self.app.route('/stays/<stay_id:int>/favorite', method='POST',
                       callback=login_required(self.toggle_favorite))

    def list_favorites(self):
        user_id = get_current_user_id()
        print("DEBUG user_id:", user_id)
        user = self.user_model.get_by_id(user_id)

        favorites = self.favorite_service.get_by_user(user_id)
        stays = self.stay_service.get_all()
        stays_by_id = {s.id: s for s in stays}
        favorite_stays = [stays_by_id[f.stay_id] for f in favorites
                          if f.stay_id in stays_by_id]

        return self.render(
            'favorites',
            user_id=user_id,
            user=user,
            favorites=favorites,
            favorite_stays=favorite_stays
        )

    def toggle_favorite(self, stay_id):
        user_id = get_current_user_id()
        self.favorite_service.toggle_favorite(user_id, stay_id)
        self.redirect('/favorites')


favorite_routes = Bottle()
favorite_controller = FavoriteController(favorite_routes)
