from bottle import Bottle, request, redirect
from .base_controller import BaseController
from services.review_service import ReviewService
from models.stay import StayModel
from models.user import UserModel
from utils import get_current_user_id


class ReviewController(BaseController):
    def __init__(self, app):
        super().__init__(app)
        self.review_service = ReviewService()
        self.stay_model = StayModel()
        self.user_model = UserModel()
        self.setup_routes()

    def setup_routes(self):
        self.app.route('/reviews', method='GET', callback=self.list_reviews)

        self.app.route(
            '/stays/<stay_id:int>/reviews',
            method='GET',
            callback=self.list_reviews_by_stay
        )

        self.app.route(
            '/stays/<stay_id:int>/reviews/add',
            method=['GET', 'POST'],
            callback=self.add_review
        )

        self.app.route(
            '/reviews/edit/<review_id:int>',
            method=['GET', 'POST'],
            callback=self.edit_review
        )

        self.app.route(
            '/reviews/delete/<review_id:int>',
            method='POST',
            callback=self.delete_review
        )

    def list_reviews(self):
        reviews = self.review_service.get_all()
        return self.render('reviews', reviews=reviews)

    def list_reviews_by_stay(self, stay_id):
        stay = self.stay_model.get_by_id(stay_id)
        reviews = self.review_service.get_by_stay(stay_id)

        users_by_id = {}
        for r in reviews:
            if r.user_id not in users_by_id:
                user = self.user_model.get_by_id(r.user_id)
                users_by_id[r.user_id] = user.name if user else f"Usuário #{r.user_id}"

        try:
            current_user_id = get_current_user_id()
        except Exception:
            current_user_id = None

        return self.render(
            'stay_reviews',
            stay=stay,
            reviews=reviews,
            current_user_id=current_user_id,
            users_by_id=users_by_id
        )

    def add_review(self, stay_id):
        if request.method == 'GET':
            stay = self.stay_model.get_by_id(stay_id)
            return self.render(
                'review_form',
                review=None,
                stay=stay,
                stay_id=stay_id,
                action=f"/stays/{stay_id}/reviews/add"
            )
        else:
            try:
                user_id = get_current_user_id()
            except Exception:
                user_id = int(request.forms.get('user_id') or 1)

            self.review_service.save(stay_id, user_id)
            self.redirect(f"/stays/{stay_id}/reviews")

    def edit_review(self, review_id):
        review = self.review_service.get_by_id(review_id)

        if not review:
            return "Review não encontrada"

        try:
            current_user_id = get_current_user_id()
        except Exception:
            current_user_id = None

        if current_user_id is None or review.user_id != current_user_id:
            return "Você não tem permissão para editar esta review."

        if request.method == 'GET':
            stay = self.stay_model.get_by_id(review.stay_id)
            return self.render(
                'review_form',
                review=review,
                stay=stay,
                stay_id=review.stay_id,
                action=f"/reviews/edit/{review_id}"
            )
        else:
            self.review_service.edit_review(review)
            self.redirect(f"/stays/{review.stay_id}/reviews")

    def delete_review(self, review_id):
        review = self.review_service.get_by_id(review_id)
        if not review:
            return "Review não encontrada"

        try:
            current_user_id = get_current_user_id()
        except Exception:
            current_user_id = None

        if current_user_id is None or review.user_id != current_user_id:
            return "Você não tem permissão para excluir esta review."

        stay_id = review.stay_id
        self.review_service.delete_review(review_id)
        self.redirect(f"/stays/{stay_id}/reviews")


review_routes = Bottle()
review_controller = ReviewController(review_routes)
