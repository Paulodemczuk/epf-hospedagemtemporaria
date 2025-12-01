from typing import List, Optional
from bottle import request
from models.review import ReviewModel, Review


class ReviewService:
    def __init__(self):
        self.model = ReviewModel()

    def _reload(self):
        self.model = ReviewModel()

    def get_all(self) -> List[Review]:
        self._reload()
        return self.model.get_all()

    def get_by_id(self, review_id: int) -> Optional[Review]:
        self._reload()
        return self.model.get_by_id(review_id)

    def get_by_stay(self, stay_id: int) -> List[Review]:
        self._reload()
        return self.model.get_by_stay(stay_id)

    def _next_id(self) -> int:
        self._reload()
        reviews = self.model.get_all()
        if not reviews:
            return 1
        return max(r.id for r in reviews) + 1

    def _normalize_rating(self, rating_raw) -> int:
        try:
            rating = int(rating_raw)
        except (TypeError, ValueError):
            rating = 0
        if rating < 1:
            rating = 1
        if rating > 5:
            rating = 5
        return rating

    def _normalize_recomenda(self, recom_raw) -> bool:
        return True if recom_raw == 'sim' else False

    def save(self, stay_id: int, user_id: int):
        form = request.forms
        rating = self._normalize_rating(form.get('rating'))
        comment = form.get('comment') or ''
        recom_raw = form.get('recomenda') 
        recomenda = self._normalize_recomenda(recom_raw)

        review = Review(
            id=self._next_id(),
            stay_id=stay_id,
            user_id=user_id,
            rating=rating,
            comment=comment,
            recomenda=recomenda
        )
        self.model.add_review(review)
        return None

    def edit_review(self, review: Review):
        form = request.forms
        new_rating = form.get('rating')
        new_comment = form.get('comment')
        recom_raw = form.get('recomenda')

        if new_rating is not None:
            review.rating = self._normalize_rating(new_rating)
        if new_comment is not None:
            review.comment = new_comment or review.comment
        if recom_raw is not None:
            review.recomenda = self._normalize_recomenda(recom_raw)

        self.model.update_review(review)
        return None

    def delete_review(self, review_id: int):
        self.model.delete_review(review_id)
