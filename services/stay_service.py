from typing import List, Optional
from bottle import request
from models.stay import StayModel, Stay


class StayService:
    def __init__(self):
        self.model = StayModel()

    def _reload(self):
        self.model = StayModel()

    def get_all(self) -> List[Stay]:
        self._reload()
        return self.model.get_all()

    def search(self, city: Optional[str] = None) -> List[Stay]:
        self._reload()
        stays = self.model.get_all()
        if city:
            city_lower = city.lower()
            stays = [s for s in stays if s.city.lower().startswith(city_lower)]
        return stays

    def get_by_id(self, stay_id: int) -> Optional[Stay]:
        self._reload()
        return self.model.get_by_id(stay_id)

    def _next_id(self) -> int:
        self._reload()
        stays = self.model.get_all()
        if not stays:
            return 1
        return max(s.id for s in stays) + 1

    def save(self, host_id: int):
        form = request.forms
        title = form.get('title')
        city = form.get('city')
        price_per_night = form.get('price_per_night')
        max_guests = form.get('max_guests')

        # checkboxes de features
        features_raw = request.forms.getall('features_ids')
        features_ids = [int(f) for f in features_raw]

        stay = Stay(
            id=self._next_id(),
            title=title,
            city=city,
            price_per_night=price_per_night,
            max_guests=max_guests,
            host_id=host_id,
            features_ids=features_ids
        )
        self.model.add_stay(stay)

    def edit_stay(self, stay: Stay):
        form = request.forms
        stay.title = form.get('title') or stay.title
        stay.city = form.get('city') or stay.city
        stay.price_per_night = float(
            form.get('price_per_night') or stay.price_per_night
        )
        stay.max_guests = int(
            form.get('max_guests') or stay.max_guests
        )

        features_raw = request.forms.getall('features_ids')
        stay.features_ids = [int(f) for f in features_raw]

        self.model.update_stay(stay)

    def delete_stay(self, stay_id: int):
        self.model.delete_stay(stay_id)
