from typing import List, Optional
from bottle import request
import os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import io
import base64
from collections import Counter
from models.stay import StayModel, Stay

UPLOAD_DIR = os.path.join(os.path.dirname(__file__), '..', 'static', 'img', 'stays')

class StayService:


    def __init__(self):
        self.model = StayModel()
        if not os.path.exists(UPLOAD_DIR):
            os.makedirs(UPLOAD_DIR)

    def _reload(self):
        self.model = StayModel()

    def get_all(self) -> List[Stay]:
        self._reload()
        return self.model.get_all()

    def search(self, city: Optional[str] = None, feature_ids: Optional[list[int]] = None) -> List[Stay]:
        self._reload()
        stays = self.model.get_all()
        if city:
            city_lower = city.lower()
            stays = [s for s in stays if s.city.lower().startswith(city_lower)]

        if feature_ids:
            feature_ids_set = set(feature_ids)
            stays = [s for s in stays if feature_ids_set.issubset(set(s.features_ids))
        ]

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
    
    def get_stays_by_city_chart(self):
        self._reload()
        stays = self.model.get_all()
        
        if not stays:
            return None

        cities = [s.city for s in stays]
        counts = Counter(cities)
        
        labels_cites = list(counts.keys())
        sizes = list(counts.values())

        plt.figure(figsize=(6, 4))

        colors = ['#2f1c6a', '#5e35b1', '#7e57c2', '#9575cd', '#b39ddb']
        
        plt.pie(sizes, labels=labels_cites, autopct='%1.1f%%', 
                startangle=140, colors=colors[:len(labels_cites)])
        
        plt.title('Stays por Cidade', fontsize=14, fontweight='bold', color='#333')
        plt.tight_layout()

        img_buffer = io.BytesIO()
        plt.savefig(img_buffer, format='png')
        img_buffer.seek(0)
        plt.close()

        return base64.b64encode(img_buffer.getvalue()).decode('utf-8')

    def save(self, host_id: int):
        form = request.forms
        title = form.get('title')
        city = form.get('city')
        price_per_night = form.get('price_per_night')
        max_guests = form.get('max_guests')
        
        features_raw = request.forms.getall('features_ids')
        features_ids = [int(f) for f in features_raw]
        new_id = self._next_id()

        image_upload = request.files.get('image_file')
        image_filename = self._save_image_file(image_upload,new_id)

        stay = Stay(
            id=new_id,
            title=title,
            city=city,
            price_per_night=price_per_night,
            max_guests=max_guests,
            host_id=host_id,
            features_ids=features_ids,
            image_filename=image_filename
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

        image_upload=request.files.get('image_file')
        if image_upload:
            new_filename = self._save_image_file(image_upload, stay.id)
            if new_filename:
                stay.image_filename = new_filename

        self.model.update_stay(stay)

    def delete_stay(self, stay_id: int):
        self.model.delete_stay(stay_id)

    def _save_image_file(self,file_upload,stay_id):
        if not file_upload:
            return None
        
        name, ext = os.path.splitext(file_upload.filename)
        if ext.lower() not in ('.png', '.jpg', '.jpeg'):
            return None
        
        filename = f"stay_{stay_id}{ext}"
        save_path = os.path.join(UPLOAD_DIR,filename)

        file_upload.save(save_path, overwrite=True)
        return filename
    
    def get_by_host(self, host_id: int) -> List[Stay]:
        self._reload()
        stays = self.model.get_all()
        return [s for s in stays if s.host_id == host_id]

    def delete_by_host(self, host_id: int):
        self._reload()
        stays = self.model.get_all()
        stays_to_keep = [s for s in stays if s.host_id != host_id]
        self.model.stays = stays_to_keep
        self.model._save()
