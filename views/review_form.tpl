% rebase('layout', title='Review')

<style>
  .review-form-container {
      max-width: 600px;
      margin: 0 auto;
  }
  .review-form-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 14px 16px;
      font-size: 20px;
      color: #2f1c6a;
  }
  .review-form-card h1 {
      margin-top: 0;
      font-size: 30px;
      margin-bottom: 10px;
  }
  .review-form-group {
      margin-bottom: 10px;
  }
  .review-form-group label {
      display: block;
      margin-bottom: 4px;
      font-weight: bold;
  }
  .review-form-group input[type="number"],
  .review-form-group textarea {
      width: 100%;
      padding: 6px;
      border-radius: 4px;
      border: 1px solid #ccc;
      font-family: inherit;
      font-size: 17px;
  }
  .review-form-actions {
      margin-top: 10px;
      display: flex;
      gap: 8px;
  }

  .btn-primary-review,
  .btn-primary-review:link,
  .btn-primary-review:visited {
      display: inline-block;
      font-size: 17px;
      padding: 6px 14px;
      border-radius: 4px;
      border: none;
      background-color: #2f1c6a;
      color: #fafbff;
      cursor: pointer;
      text-decoration: none;
  }

  .btn-secondary-review,
  .btn-secondary-review:link,
  .btn-secondary-review:visited {
      display: inline-block;
      font-size: 13px;
      padding: 6px 10px;
      border-radius: 4px;
      border: 1px solid #ccc;
      background-color: #ffffff;
      color: #333;
      cursor: pointer;
      text-decoration: none;
  }
</style>

<div class="review-form-container">
  <div class="review-form-card">
      <h1>{{'Editar review' if review else 'Adicionar review'}}</h1>
      <p>Stay: {{stay.title}}</p>

      <form method="post" action="{{action}}">
          <div class="review-form-group">
              <label for="rating">Nota (1 a 5)</label>
              <input type="number" id="rating" name="rating"
                     min="1" max="5" step="1"
                     value="{{review.rating if review else '5'}}" required>
          </div>

          <div class="review-form-group">
              <label>Você recomenda?</label>
              % recomendo = None
              % if review:
              %     recomendo = 'sim' if getattr(review, 'recomenda', True) else 'nao'
              % end
              <label>
                  <input type="radio" name="recomenda" value="sim"
                         {{'checked' if not review or recomendo == 'sim' else ''}}>
                  Recomendo
              </label>
              <label>
                  <input type="radio" name="recomenda" value="nao"
                         {{'checked' if recomendo == 'nao' else ''}}>
                  Não recomendo
              </label>
          </div>

          <div class="review-form-group">
              <label for="comment">Comentário</label>
              <textarea id="comment" name="comment" rows="4">{{review.comment if review else ''}}</textarea>
          </div>

          <div class="review-form-actions">
              <button type="submit" class="btn-primary-review">
                  {{'Salvar alterações' if review else 'Enviar review'}}
              </button>
              <a href="/stays/{{stay_id}}/reviews" class="btn-secondary-review">Cancelar</a>
          </div>
      </form>
  </div>
</div>
