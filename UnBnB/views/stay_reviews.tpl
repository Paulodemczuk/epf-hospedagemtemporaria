% rebase('layout', title='Reviews')

<style>
  .reviews-container {
      max-width: 800px;
      margin: 0 auto;
  }
  .reviews-header {
      margin-bottom: 15px;
  }
  .reviews-header h1 {
      margin: 0;
      font-size: 24px;
  }
  .reviews-summary {
      font-size: 14px;
      color: #555;
  }
  .reviews-list {
      list-style: none;
      padding: 0;
      margin: 0;
      display: flex;
      flex-direction: column;
      gap: 10px;
  }
  .review-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 20px 24px;
      font-size: 20px;
      color: #2f1c6a
  }
  .review-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 4px;
  }
  .review-author {
      font-weight: bold;
      font-size: 22px;
  }
  .review-rating-line {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 6px;
  }
  .review-stars {
      color: #ffb400;
      font-size: 20px;
  }
  .review-badge {
      padding: 2px 6px;
      border-radius: 10px;
      font-size: 11px;
      font-weight: bold;
  }
  .review-badge.good {
      background-color: #e6f4ea;
      color: #1e7a34;
  }
  .review-badge.bad {
      background-color: #fdecea;
      color: #b3261e;
  }
  .review-comment {
      margin-top: 4px;
      line-height: 1.4;
  }
  .review-actions {
      margin-top: 6px;
      font-size: 12px;
  }
  .review-actions form {
      display: inline;
  }
  .review-actions {
      margin-top: 6px;
      display: flex;
      gap: 6px;
  }
  .btn-review {
      display: inline-block;
      font-size: 15px;
      padding: 6px 16px;
      border-radius: 3px;
      border: none;
      background-color: #2f1c6a;
      color: #fafbff;
      cursor: pointer;
      text-decoration: none;
      line-height: 1.2;
  }
  .btn-review.delete {
      background-color: #b3261e;
  }
  .review-actions form {
      display: inline;
      margin: 0;
  }
</style>

<div class="reviews-container">
  <div class="reviews-header">
      <h1>Reviews de {{stay.title}}</h1>
      <p class="reviews-summary">
          Média: {{f"{(sum(r.rating for r in reviews) / len(reviews)):.2f}" if reviews else '—'}} / 5 - {{len(reviews)}} review(s)
      </p>
      <p>
          <a href="/stays/{{stay.id}}">Voltar para a stay</a> |
          <a href="/stays/{{stay.id}}/reviews/add">Adicionar review</a>
      </p>
  </div>

  <ul class="reviews-list">
  % for review in reviews:
      % filled = int(review.rating)
      % empty = 5 - filled
      <li class="review-card">
          <div class="review-top">
              <span class="review-author">{{users_by_id.get(review.user_id, 'Usuário #' + str(review.user_id))}}
              </span>
              <span>Nota: {{review.rating}} / 5</span>
          </div>

          <div class="review-rating-line">
              <span class="review-stars">
                  % for i in range(filled):
                      ★
                  % end
                  % for i in range(empty):
                      ☆
                  % end
              </span>
              % if getattr(review, 'recomenda', True):
                  <span class="review-badge good">Recomendaria</span>
              % else:
                  <span class="review-badge bad">Não recomendaria</span>
              % end
          </div>

          <div class="review-comment">
              % if review.comment and review.comment.strip():
                  {{review.comment}}
              % else:
                  <em>Sem comentário.</em>
              % end
          </div>

          <div class="review-actions">
                % if defined('current_user_id') and current_user_id and review.user_id == current_user_id:
                    <a href="/reviews/edit/{{review.id}}" class="btn-review">Editar</a>
                    <form action="/reviews/delete/{{review.id}}" method="post">
                        <button type="submit" class="btn-review delete">Excluir</button>
                    </form>
                % end
            </div>
      </li>
  % end
  </ul>
</div>
