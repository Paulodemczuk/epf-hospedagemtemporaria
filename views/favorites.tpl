% rebase('layout', title='Favoritos')

<style>
  .favorites-container {
      max-width: 1100px;
      margin: 20px auto 40px;
      padding: 0 20px;
      font-family: "Poppins", sans-serif;
      color: #2f1c6a;
  }

  .favorites-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;
  }

  .favorites-header h1 {
      margin: 0;
      font-size: 26px;
  }

  .favorites-header a {
      font-size: 14px;
      color: #2f1c6a;
      text-decoration: none;
  }

  .favorites-header a:hover {
      text-decoration: underline;
  }

  .favorites-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 16px;
      margin-top: 12px;
  }

  .favorite-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      overflow: hidden;
      font-size: 14px;
      display: flex;
      flex-direction: column;
  }

  .favorite-card-img {
      width: 100%;
      height: 500px;
      object-fit: cover;
      display: block;
  }

  .favorite-card-body {
      padding: 10px 14px 12px 14px;
      display: flex;
      flex-direction: column;
      gap: 4px;
  }

  .favorite-card-title {
      font-weight: 600;
      font-size: 16px;
  }

  .favorite-card-meta {
      color: #555;
      font-size: 13px;
  }

  .favorite-card-actions {
      margin-top: 8px;
      display: flex;
      gap: 8px;
  }

    .btn-fav-remove,
    .btn-fav-details {
        display: inline-flex;        
        align-items: center;
        justify-content: center;
        padding: 5px 12px;
        border-radius: 4px;
        font-size: 15px;
        line-height: 1.7;               
        box-sizing: border-box;
    }

    .btn-fav-remove {
        border: 1px solid #2f1c6a;
        background-color: #2f1c6a;
        color: #fafbff;
        cursor: pointer;
    }

    .btn-fav-details {
        border: 1px solid #2f1c6a;
        background-color: #ffffff;
        color: #2f1c6a;
        text-decoration: none;
    }
</style>

<div class="favorites-container">
  <div class="favorites-header">
      <h1>Favoritos de {{user.name if user else user_id}}</h1>
      <a href="/stays">Voltar para Stays</a>
  </div>

  % if favorite_stays:
      <div class="favorites-grid">
      % for stay in favorite_stays:
          <div class="favorite-card">
              % if stay.image_filename:
                  <img class="favorite-card-img"
                       src="/static/img/stays/{{stay.image_filename}}"
                       alt="{{stay.title}}">
              % end

              <div class="favorite-card-body">
                  <div class="favorite-card-title">{{stay.title}}</div>
                  <div class="favorite-card-meta">
                      {{stay.city}} · R$ {{f"{stay.price_per_night:.2f}"}} / noite · Máx hóspedes: {{stay.max_guests}}
                  </div>

                  <div class="favorite-card-actions">
                      <form action="/stays/{{stay.id}}/favorite" method="post">
                          <input type="hidden" name="user_id" value="{{user_id}}">
                          <button type="submit" class="btn-fav-remove">Remover</button>
                      </form>
                      <a href="/stays/{{stay.id}}" class="btn-fav-details">Ver detalhes</a>
                  </div>
              </div>
          </div>
      % end
      </div>
  % else:
      <p>Você ainda não tem stays favoritas.</p>
  % end
</div>
