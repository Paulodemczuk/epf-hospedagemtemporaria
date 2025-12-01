from bottle import Bottle, request
from .base_controller import BaseController
from services.stay_service import StayService


class StayController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.stay_service = StayService()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/stays', method='GET', callback=self.list_stays)
        self.app.route('/stays/add', method=['GET', 'POST'], callback=self.add_stay)
        self.app.route('/stays/edit/<stay_id:int>', method=['GET', 'POST'], callback=self.edit_stay)
        self.app.route('/stays/delete/<stay_id:int>', method='POST', callback=self.delete_stay)

    def list_stays(self):
        city = request.query.get('city')  
        stays = self.stay_service.search(city=city)
        return self.render('stays', stays=stays, city=city)


    def add_stay(self):
        if request.method == 'GET':
            return self.render('stay_form', stay=None, action="/stays/add")
        else:
            host_id = int(request.forms.get('host_id') or 1)
            self.stay_service.save(host_id)
            self.redirect('/stays')

    def edit_stay(self, stay_id):
        stay = self.stay_service.get_by_id(stay_id)
        if not stay:
            return "Stay não encontrada"

        if request.method == 'GET':
            return self.render('stay_form', stay=stay, action=f"/stays/edit/{stay_id}")
        else:
            self.stay_service.edit_stay(stay)
            self.redirect('/stays')

    def delete_stay(self, stay_id):
        self.stay_service.delete_stay(stay_id)
        self.redirect('/stays')


stay_routes = Bottle()
stay_controller = StayController(stay_routes)
