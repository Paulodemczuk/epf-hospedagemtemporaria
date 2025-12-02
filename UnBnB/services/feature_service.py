from typing import List, Optional
from bottle import request
from models.feature import FeatureModel, Feature


class FeatureService:
    def __init__(self):
        self.model = FeatureModel()

    def _reload(self):
        self.model = FeatureModel()

    def get_all(self) -> List[Feature]:
        self._reload()
        return self.model.get_all()

    def get_by_id(self, feature_id: int) -> Optional[Feature]:
        self._reload()
        return self.model.get_by_id(feature_id)

    def _next_id(self) -> int:
        self._reload()
        features = self.model.get_all()
        if not features:
            return 1
        return max(f.id for f in features) + 1

    def save(self):
        form = request.forms
        name = form.get('name') or ''
        icon = form.get('icon') or ''

        feature = Feature(
            id=self._next_id(),
            name=name,
            icon=icon
        )
        self.model.add_feature(feature)

    def edit_feature(self, feature: Feature):
        form = request.forms
        feature.name = form.get('name') or feature.name
        feature.icon = form.get('icon') or feature.icon
        self.model.update_feature(feature)

    def delete_feature(self, feature_id: int):
        self.model.delete_feature(feature_id)
