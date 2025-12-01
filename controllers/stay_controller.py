from bottle import Bottle, request
from .base_controller import BaseController
from services.stay_service import StayService
from services.review_service import ReviewService
from services.feature_service import FeatureService
from utils import login_required, get_current_user_id
from models.user import UserModel


class StayController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.stay_service = StayService()
        self.review_service = ReviewService()
        self.feature_service = FeatureService()
        self.user_model = UserModel()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/stays', method='GET', callback=self.list_stays)
        self.app.route('/stays/add', method=['GET', 'POST'], callback=login_required(self.add_stay))
        self.app.route('/stays/edit/<stay_id:int>', method=['GET', 'POST'],
                       callback=login_required(self.edit_stay))
        self.app.route('/stays/delete/<stay_id:int>', method='POST',
                       callback=self.delete_stay)
        self.app.route('/stays/<stay_id:int>', method='GET',
                       callback=self.show_stay)
        self.app.route('/my-stays', method='GET',
                   callback=login_required(self.list_my_stays))

    def list_stays(self):
        city = request.query.get('city')

        feature_ids_raw = request.query.getall('features_ids')
        feature_ids = [int(f) for f in feature_ids_raw] if feature_ids_raw else []

        rating_ranges = request.query.getall('rating_range')

        stays = self.stay_service.search(city=city, feature_ids=feature_ids)

        ratings_by_stay = {}
        acceptance_by_stay = {}

        for stay in stays:
            reviews = self.review_service.get_by_stay(stay.id)
            if reviews:
                avg = sum(r.rating for r in reviews) / len(reviews)
                ratings_by_stay[stay.id] = int(avg) if avg.is_integer() else round(avg, 1)

                total = len(reviews)
                recomendam = sum(1 for r in reviews if getattr(r, 'recomenda', True))
                acceptance = (recomendam / total) * 100
                acceptance_by_stay[stay.id] = int(acceptance) if acceptance.is_integer() else round(acceptance, 1)
            else:
                ratings_by_stay[stay.id] = None
                acceptance_by_stay[stay.id] = None

        if rating_ranges:
            def in_any_range(stay_id):
                rating = ratings_by_stay.get(stay_id)
                if rating is None:
                    return False
                for r in rating_ranges:
                    low_str, high_str = r.split('-')
                    low = float(low_str)
                    high = float(high_str)
                    if low <= rating <= high:
                        return True
                return False
            
            stays = [s for s in stays if in_any_range(s.id)]

        all_features = self.feature_service.get_all()

        return self.render(
            'stays',
            stays=stays,
            city=city,
            ratings_by_stay=ratings_by_stay,
            acceptance_by_stay=acceptance_by_stay,
            all_features=all_features, 
            selected_features=feature_ids,
            selected_rating_ranges=rating_ranges
        )

    def add_stay(self):
        
        if request.method == 'GET':
            features = self.feature_service.get_all()
            return self.render(
                'stay_form',
                stay=None,
                action="/stays/add",
                features=features
            )
        else:
            host_id = int(request.forms.get('host_id') or 1)
            self.stay_service.save(get_current_user_id())
            self.redirect('/stays?msg=Stay+criada+com+sucesso')

    def edit_stay(self, stay_id):
        stay = self.stay_service.get_by_id(stay_id)
        if not stay:
            return "Stay não encontrada"

        if request.method == 'GET':
            features = self.feature_service.get_all()
            return self.render(
                'stay_form',
                stay=stay,
                action=f"/stays/edit/{stay_id}",
                features=features
            )
        else:
            self.stay_service.edit_stay(stay)
            self.redirect('/stays')

    def delete_stay(self, stay_id):
        self.stay_service.delete_stay(stay_id)
        self.redirect('/stays')

    def show_stay(self, stay_id):
        stay = self.stay_service.get_by_id(stay_id)
        if not stay:
            return "Stay não encontrada"

        all_features = self.feature_service.get_all()
        features_by_id = {f.id: f for f in all_features}
        stay_features = [features_by_id[fid] for fid in stay.features_ids
                         if fid in features_by_id]
        
        host = self.user_model.get_by_id(stay.host_id)

        return self.render(
            'stay_details',
            stay=stay,
            features=stay_features,
            host=host
        )
    
    def list_my_stays(self):
        user_id = get_current_user_id()
        stays = self.stay_service.get_by_host(user_id)
        
        ratings_by_stay = {}
        acceptance_by_stay = {}

        for stay in stays:
            reviews = self.review_service.get_by_stay(stay.id)
            if reviews:
                avg = sum(r.rating for r in reviews) / len(reviews)
                if avg.is_integer():
                    ratings_by_stay[stay.id] = int(avg)
                else:
                    ratings_by_stay[stay.id] = round(avg, 1)

                total = len(reviews)
                recomendam = sum(
                    1 for r in reviews if getattr(r, 'recomenda', True)
                )
                acceptance = (recomendam / total) * 100
                if acceptance.is_integer():
                    acceptance_by_stay[stay.id] = int(acceptance)
                else:
                    acceptance_by_stay[stay.id] = round(acceptance, 1)
            else:
                ratings_by_stay[stay.id] = None
                acceptance_by_stay[stay.id] = None

        return self.render(
            'stays',
            stays=stays,
            city=None,
            ratings_by_stay=ratings_by_stay,
            acceptance_by_stay=acceptance_by_stay,
            my_stays=True
        )


stay_routes = Bottle()
stay_controller = StayController(stay_routes)
