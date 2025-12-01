from typing import List, Optional
from bottle import request
from models.stay import StayModel, Stay


class StayService:
    def __init__(self):
        self.model = StayModel()

    def get_all(self) -> List[Stay]:
        return self.model.get_all()

    def get_by_id(self, stay_id: int) -> Optional[Stay]:
        return self.model.get_by_id(stay_id)

    def _next_id(self) -> int:
        stays = self.model.get_all()
        if not stays:
            return 1
        return max(s.id for s in stays) + 1

    def save(self, host_id: int):
        form = request.forms
        stay = Stay(
            id=self._next_id(),
            host_id=host_id,
            title=form.get('title'),
            description=form.get('description') or '',
            city=form.get('city'),
            price_per_night=form.get('price_per_night'),
            max_guests=form.get('max_guests')
        )
        self.model.add_stay(stay)

    def edit_stay(self, stay: Stay):
        form = request.forms
        stay.title = form.get('title')
        stay.description = form.get('description') or ''
        stay.city = form.get('city')
        stay.price_per_night = float(form.get('price_per_night'))
        stay.max_guests = int(form.get('max_guests'))
        self.model.update_stay(stay)

    def delete_stay(self, stay_id: int):
        self.model.delete_stay(stay_id)

    def search(self, city: str = None):
        stays = self.model.get_all()
        if city:
            stays = [s for s in stays if s.city.lower() == city.lower()]
        return stays
