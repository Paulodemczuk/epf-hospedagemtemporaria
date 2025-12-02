% rebase('layout', title='Stay')

<style>
  .stay-form-container {
      max-width: 700px;
      margin: 0 auto;
      margin-top: 100px;
  }

  .stay-form-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 18px 20px;
      font-size: 16px;
      color: #2f1c6a;
  }

  .stay-form-card h1 {
      margin-top: 0;
      font-size: 28px;
      margin-bottom: 4px;
  }

  .stay-form-subtitle {
      margin: 0 0 16px 0;
      color: #666;
      font-size: 14px;
  }

  .stay-form-group {
      margin-bottom: 12px;
  }

  .stay-form-group label {
      display: block;
      margin-bottom: 4px;
      font-weight: 600;
  }

  .stay-form-group input[type="text"],
  .stay-form-group input[type="number"],
  .stay-form-group input[type="file"] {
      width: 100%;
      padding: 6px 8px;
      border-radius: 4px;
      border: 1px solid #ccc;
      font-family: inherit;
      font-size: 15px;
      box-sizing: border-box;
  }

  .stay-form-inline {
      display: flex;
      gap: 12px;
  }

  .stay-form-inline .stay-form-group {
      flex: 1;
  }

  .stay-image-box {
      border: 1px solid #ddd;
      border-radius: 5px;
      padding: 10px;
      margin: 8px 0 4px 0;
      background: #fff;
  }

  .stay-current-image {
      margin: 8px 0;
  }

  .stay-current-image img {
      max-width: 200px;
      border-radius: 4px;
  }

  .stay-features-box {
      border-top: 1px solid #e0e0e0;
      margin-top: 12px;
      padding-top: 12px;
  }

  .stay-features-title {
      font-weight: 600;
      margin-bottom: 6px;
  }

  .stay-features-list {
      max-height: 180px;
      overflow-y: auto;
      padding: 4px 0;
  }

  .stay-features-list label {
      display: block;
      font-weight: 400;
      margin-bottom: 4px;
  }

  .stay-form-actions {
      margin-top: 16px;
      display: flex;
      gap: 8px;
  }

  .btn-primary-stay,
  .btn-primary-stay:link,
  .btn-primary-stay:visited {
      display: inline-block;
      font-size: 15px;
      padding: 6px 14px;
      border-radius: 4px;
      border: none;
      background-color: #2f1c6a;
      color: #fafbff;
      cursor: pointer;
      text-decoration: none;
  }

  .btn-secondary-stay,
  .btn-secondary-stay:link,
  .btn-secondary-stay:visited {
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

<div class="stay-form-container">
  <div class="stay-form-card">
      <h1>{{'Editar stay' if stay else 'Nova stay'}}</h1>
      <p class="stay-form-subtitle">
          Preencha as informações da hospedagem abaixo.
      </p>

      <form method="post" action="{{action}}" enctype="multipart/form-data">
          <div class="stay-form-group">
              <label for="title">Nome da Stay</label>
              <input type="text" id="title" name="title"
                     value="{{stay.title if stay else ''}}" required>
          </div>

          <div class="stay-form-inline">
              <div class="stay-form-group">
                  <label for="city">Cidade</label>
                  <input type="text" id="city" name="city"
                         value="{{stay.city if stay else ''}}" required>
              </div>

              <div class="stay-form-group">
                  <label for="price_per_night">Preço por noite (R$)</label>
                  <input type="number" step="0.01" id="price_per_night" name="price_per_night"
                         value="{{stay.price_per_night if stay else ''}}" required>
              </div>

              <div class="stay-form-group">
                  <label for="max_guests">Máx hóspedes</label>
                  <input type="number" id="max_guests" name="max_guests" min="1"
                         value="{{stay.max_guests if stay else '1'}}" required>
              </div>
          </div>

          <div class="stay-form-group">
              <label>Imagem da hospedagem</label>
              <div class="stay-image-box">
                  % if stay and stay.image_filename and stay.image_filename != 'default.jpg':
                      <div class="stay-current-image">
                          <img src="/static/img/stays/{{stay.image_filename}}" alt="Foto atual">
                          <br><small style="color:#666;">Imagem atual</small>
                      </div>
                  % end

                  <input type="file" name="image_file"
                         accept="image/png, image/jpeg, image/jpg">
                  <small style="color:#666;">Formatos aceitos: JPG, PNG</small>
              </div>
          </div>

          <div class="stay-features-box">
              <div class="stay-features-title">Comodidades / Tipo</div>
              <div class="stay-features-list">
                  % selected = set(stay.features_ids) if stay else set()
                  % for f in features:
                      <label>
                          <input type="checkbox" name="features_ids" value="{{f.id}}"
                                 {{'checked' if f.id in selected else ''}}>
                          {{f.name}}
                      </label>
                  % end
              </div>
          </div>

          <div class="stay-form-actions">
              <button type="submit" class="btn-primary-stay">Salvar</button>
              <a href="/stays" class="btn-secondary-stay">Voltar</a>
          </div>
      </form>
  </div>
</div>
