import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


class Stay:
    def __init__(self, id, host_id, title, description, city, price_per_night, max_guests):
        self.id = id
        self.host_id = host_id
        self.title = title
        self.description = description
        self.city = city
        self.price_per_night = float(price_per_night)
        self.max_guests = int(max_guests)

    def __repr__(self):
        return (
            f"Stay(id={self.id}, host_id={self.host_id}, title='{self.title}', "
            f"city='{self.city}', price_per_night={self.price_per_night}, "
            f"max_guests={self.max_guests})"
        )

    def to_dict(self):
        return {
            'id': self.id,
            'host_id': self.host_id,
            'title': self.title,
            'description': self.description,
            'city': self.city,
            'price_per_night': self.price_per_night,
            'max_guests': self.max_guests
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            host_id=data['host_id'],
            title=data['title'],
            description=data.get('description', ''),
            city=data['city'],
            price_per_night=data['price_per_night'],
            max_guests=data['max_guests']
        )


class StayModel:
    FILE_PATH = os.path.join(DATA_DIR, 'stays.json')

    def __init__(self):
        self.stays = self._load()

    def _load(self):
        if not os.path.exists(self.FILE_PATH):
            return []
        with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [Stay(**item) for item in data]

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([s.to_dict() for s in self.stays], f, indent=4, ensure_ascii=False)

    def get_all(self):
        return self.stays

    def get_by_id(self, stay_id: int):
        return next((s for s in self.stays if s.id == stay_id), None)

    def add_stay(self, stay: Stay):
        self.stays.append(stay)
        self._save()

    def update_stay(self, updated_stay: Stay):
        for i, stay in enumerate(self.stays):
            if stay.id == updated_stay.id:
                self.stays[i] = updated_stay
                self._save()
                break

    def delete_stay(self, stay_id: int):
        self.stays = [s for s in self.stays if s.id != stay_id]
        self._save()
