import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


class Feature:
    def __init__(self, id, name, icon=""):
        self.id = id
        self.name = name
        self.icon = icon

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'icon': self.icon
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            name=data['name'],
            icon=data.get('icon', '')
        )


class FeatureModel:
    FILE_PATH = os.path.join(DATA_DIR, 'features.json')

    def __init__(self):
        self.features = self._load()

    def _load(self):

        if not os.path.exists(self.FILE_PATH):
            default = [
                Feature(1, "Wi-Fi"),
                Feature(2, "Ar-condicionado"),
                Feature(3, "Piscina"),
                Feature(4, "Cozinha"),
                Feature(5, "Estacionamento"),
                Feature(6, "Café da manhã"),
                Feature(7, "TV"),
                Feature(8, "Lavanderia"),
                Feature(9, "Academia"),
                Feature(10, "Jacuzzi"),
                Feature(11, "Vista para o mar"),
                Feature(12, "Pet-friendly"),
                Feature(13, "Churrasqueira"),
                Feature(14, "Elevador"),
                Feature(15, "Aquecimento"),
                Feature(16, "Crianças são bem-vindas"),
                Feature(17, "Trabalho remoto"),
                Feature(18, "Área de estar externa"),
                Feature(19, "Segurança 24h"),
                Feature(20, "Serviço de limpeza"),
                Feature(21, "Apartamento"),
                Feature(22, "Casa"),
            ]
            
            with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
                json.dump([ftr.to_dict() for ftr in default], f,
                          indent=4, ensure_ascii=False)
            return default

        with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [Feature.from_dict(item) for item in data]

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([f.to_dict() for f in self.features], f,
                      indent=4, ensure_ascii=False)

    def get_all(self):
        return self.features

    def get_by_id(self, feature_id: int):
        return next((f for f in self.features if f.id == feature_id), None)

    def add_feature(self, feature: Feature):
        self.features.append(feature)
        self._save()

    def update_feature(self, updated_feature: Feature):
        for i, feature in enumerate(self.features):
            if feature.id == updated_feature.id:
                self.features[i] = updated_feature
                self._save()
                break

    def delete_feature(self, feature_id: int):
        self.features = [f for f in self.features if f.id != feature_id]
        self._save()
