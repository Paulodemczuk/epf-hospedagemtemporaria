from bottle import Bottle, request
from .base_controller import BaseController
from services.feature_service import FeatureService


class FeatureController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.feature_service = FeatureService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/features', method='GET', callback=self.list_features)
        self.app.route('/features/add', method=['GET', 'POST'], callback=self.add_feature)
        self.app.route('/features/edit/<feature_id:int>',
                       method=['GET', 'POST'], callback=self.edit_feature)
        self.app.route('/features/delete/<feature_id:int>',
                       method='POST', callback=self.delete_feature)

    def list_features(self):
        features = self.feature_service.get_all()
        return self.render('features', features=features)

    def add_feature(self):
        if request.method == 'GET':
            return self.render('feature_form', feature=None, action="/features/add")
        else:
            self.feature_service.save()
            self.redirect('/features')

    def edit_feature(self, feature_id):
        feature = self.feature_service.get_by_id(feature_id)
        if not feature:
            return "Feature não encontrada"

        if request.method == 'GET':
            return self.render('feature_form', feature=feature,
                               action=f"/features/edit/{feature_id}")
        else:
            self.feature_service.edit_feature(feature)
            self.redirect('/features')

    def delete_feature(self, feature_id):
        self.feature_service.delete_feature(feature_id)
        self.redirect('/features')


feature_routes = Bottle()
feature_controller = FeatureController(feature_routes)
