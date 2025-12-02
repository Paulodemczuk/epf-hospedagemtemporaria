from typing import List, Optional
from models.favorite import FavoriteModel, Favorite


class FavoriteService:
    def __init__(self):
        self.model = FavoriteModel()

    def _reload(self):
        self.model = FavoriteModel()

    def get_all(self) -> List[Favorite]:
        self._reload()
        return self.model.get_all()

    def get_by_id(self, favorite_id: int) -> Optional[Favorite]:
        self._reload()
        return self.model.get_by_id(favorite_id)

    def get_by_user(self, user_id: int) -> List[Favorite]:
        self._reload()
        return self.model.get_by_user(user_id)

    def _next_id(self) -> int:
        self._reload()
        favorites = self.model.get_all()
        if not favorites:
            return 1
        return max(f.id for f in favorites) + 1

    def toggle_favorite(self, user_id: int, stay_id: int) -> bool:
        self._reload()
        existing = self.model.get_one(user_id, stay_id)
        if existing:
            self.model.delete_favorite(existing.id)
            return False
        else:
            favorite = Favorite(
                id=self._next_id(),
                user_id=user_id,
                stay_id=stay_id
            )
            self.model.add_favorite(favorite)
            return True
