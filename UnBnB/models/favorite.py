import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


class Favorite:
    def __init__(self, id, user_id, stay_id):
        self.id = id
        self.user_id = user_id
        self.stay_id = stay_id

    def to_dict(self):
        return {
            'id': self.id,
            'user_id': self.user_id,
            'stay_id': self.stay_id
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            user_id=data['user_id'],
            stay_id=data['stay_id']
        )


class FavoriteModel:
    FILE_PATH = os.path.join(DATA_DIR, 'favorites.json')

    def __init__(self):
        self.favorites = self._load()

    def _load(self):
        if not os.path.exists(self.FILE_PATH):
            return []
        with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [Favorite.from_dict(item) for item in data]

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([f.to_dict() for f in self.favorites], f,
                      indent=4, ensure_ascii=False)

    def get_all(self):
        return self.favorites

    def get_by_id(self, favorite_id: int):
        return next((f for f in self.favorites if f.id == favorite_id), None)

    def get_by_user(self, user_id: int):
        return [f for f in self.favorites if f.user_id == user_id]

    def get_one(self, user_id: int, stay_id: int):
        return next(
            (f for f in self.favorites
             if f.user_id == user_id and f.stay_id == stay_id),
            None
        )

    def add_favorite(self, favorite: Favorite):
        self.favorites.append(favorite)
        self._save()

    def delete_favorite(self, favorite_id: int):
        self.favorites = [f for f in self.favorites if f.id != favorite_id]
        self._save()
