import json
import os

DATA_DIR = os.path.join(os.path.dirname(__file__), '..', 'data')


class Review:
    def __init__(self, id, stay_id, user_id, rating, comment, recomenda=True):
        self.id = id
        self.stay_id = stay_id    
        self.user_id = user_id    
        self.rating = int(rating)   
        self.comment = comment
        self.recomenda = bool(recomenda)  

    def __repr__(self):
        return (
            f"Review(id={self.id}, stay_id={self.stay_id}, "
            f"user_id={self.user_id}, rating={self.rating}, "
            f"recomenda={self.recomenda}, comment='{self.comment}')"
        )

    def to_dict(self):
        return {
            'id': self.id,
            'stay_id': self.stay_id,
            'user_id': self.user_id,
            'rating': self.rating,
            'comment': self.comment,
            'recomenda': self.recomenda
        }

    @classmethod
    def from_dict(cls, data):
        return cls(
            id=data['id'],
            stay_id=data['stay_id'],
            user_id=data['user_id'],
            rating=data['rating'],
            comment=data.get('comment', ''),
            recomenda=data.get('recomenda', True)
        )


class ReviewModel:
    FILE_PATH = os.path.join(DATA_DIR, 'reviews.json')

    def __init__(self):
        self.reviews = self._load()

    def _load(self):
        if not os.path.exists(self.FILE_PATH):
            return []
        with open(self.FILE_PATH, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return [Review.from_dict(item) for item in data]

    def _save(self):
        with open(self.FILE_PATH, 'w', encoding='utf-8') as f:
            json.dump([r.to_dict() for r in self.reviews], f,
                      indent=4, ensure_ascii=False)

    def get_all(self):
        return self.reviews

    def get_by_id(self, review_id: int):
        return next((r for r in self.reviews if r.id == review_id), None)

    def get_by_stay(self, stay_id: int):
        return [r for r in self.reviews if r.stay_id == stay_id]

    def add_review(self, review: Review):
        self.reviews.append(review)
        self._save()

    def update_review(self, updated_review: Review):
        for i, review in enumerate(self.reviews):
            if review.id == updated_review.id:
                self.reviews[i] = updated_review
                self._save()
                break

    def delete_review(self, review_id: int):
        self.reviews = [r for r in self.reviews if r.id != review_id]
        self._save()
