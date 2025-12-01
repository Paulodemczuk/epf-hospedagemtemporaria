from bottle import Bottle, request
from .base_controller import BaseController
from services.favorite_service import FavoriteService
from services.stay_service import StayService


class FavoriteController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.favorite_service = FavoriteService()
        self.stay_service = StayService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/favorites', method='GET', callback=self.list_favorites)
        self.app.route('/stays/<stay_id:int>/favorite', method='POST',
                       callback=self.toggle_favorite)

    def list_favorites(self):
        user_id = int(request.query.get('user_id') or 1)

        favorites = self.favorite_service.get_by_user(user_id)
        stays = self.stay_service.get_all()
        stays_by_id = {s.id: s for s in stays}
        favorite_stays = [stays_by_id[f.stay_id] for f in favorites
                          if f.stay_id in stays_by_id]

        return self.render(
            'favorites',
            user_id=user_id,
            favorites=favorites,
            favorite_stays=favorite_stays
        )

    def toggle_favorite(self, stay_id):
        user_id = int(request.forms.get('user_id') or 1)
        self.favorite_service.toggle_favorite(user_id, stay_id)
        self.redirect('/favorites')


favorite_routes = Bottle()
favorite_controller = FavoriteController(favorite_routes)
