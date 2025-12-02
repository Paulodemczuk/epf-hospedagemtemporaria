% rebase('layout', title='Detalhes da Stay')

<style>
  .stay-details-container {
      max-width: 1100px;
      margin: 20px auto 40px;
      padding: 0 20px;
      font-family: "Poppins", sans-serif;
      color: #2f1c6a;
  }

  .stay-details-grid {
      display: grid;
      grid-template-columns: minmax(0, 2fr) minmax(0, 1fr);
      gap: 20px;
  }

  .stay-details-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      overflow: hidden;
  }

  .stay-details-img {
      width: 100%;
      height: 260px;
      object-fit: cover;
      display: block;
  }

  .stay-details-body {
      padding: 14px 18px 16px 18px;
  }

  .stay-details-title {
      margin: 0 0 4px 0;
      font-size: 24px;
      font-weight: 600;
  }

  .stay-details-meta {
      margin: 0 0 10px 0;
      color: #555;
      font-size: 14px;
  }

  .stay-details-host {
      margin: 0 0 12px 0;
      font-size: 14px;
  }

  .stay-details-section-title {
      margin: 0 0 6px 0;
      font-size: 15px;
      font-weight: 600;
  }

  .stay-features-chips {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-bottom: 12px;
  }

  .stay-feature-chip {
      padding: 4px 8px;
      border-radius: 12px;
      background-color: #e9ebff;
      color: #2f1c6a;
      font-size: 12px;
  }

  .stay-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 10px;
  }

  .btn-primary,
  .btn-secondary {
      display: inline-block;
      padding: 6px 14px;
      border-radius: 4px;
      font-size: 14px;
      text-decoration: none;
      box-sizing: border-box;
  }

  .btn-primary {
      background-color: #2f1c6a;
      color: #fafbff;
      border: none;
  }

  .btn-secondary {
      background-color: #ffffff;
      color: #2f1c6a;
      border: 1px solid #2f1c6a;
  }

  .stay-side-box {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.08);
      padding: 14px 16px;
      font-size: 14px;
  }

  .stay-side-box h3 {
      margin-top: 0;
      margin-bottom: 8px;
      font-size: 16px;
  }
</style>

<div class="stay-details-container">
  <div class="stay-details-grid">
      <div class="stay-details-card">
          % if stay.image_filename:
              <img class="stay-details-img"
                   src="/static/img/stays/{{stay.image_filename}}"
                   alt="{{stay.title}}">
          % end
          <div class="stay-details-body">
              <h1 class="stay-details-title">{{stay.title}}</h1>
              <p class="stay-details-meta">
                  {{stay.city}} · R$ {{f"{stay.price_per_night:.2f}"}} / noite · Máx hóspedes: {{stay.max_guests}}
              </p>
              <p class="stay-details-host">
                  <strong>Anfitrião:</strong> {{host.name if host else 'Desconhecido'}}
              </p>

              <div>
                  <div class="stay-details-section-title">Comodidades</div>
                  % if features:
                      <div class="stay-features-chips">
                      % for f in features:
                          <span class="stay-feature-chip">{{f.name}}</span>
                      % end
                      </div>
                  % else:
                      <p style="font-size:13px;color:#777;">Nenhuma comodidade cadastrada.</p>
                  % end
              </div>

              <div class="stay-actions">
                  <a href="/bookings/add/{{stay.id}}" class="btn-primary">Fazer reserva</a>
                  <a href="/stays/{{stay.id}}/reviews" class="btn-secondary">Ver reviews</a>
                  <a href="/stays" class="btn-secondary">Voltar para Stays</a>
              </div>
          </div>
      </div>

      <aside class="stay-side-box">
          <h3>Informações rápidas</h3>
          <p>Preço médio total para 1 noite: <strong>R$ {{f"{stay.price_per_night:.2f}"}}</strong></p>
          <p>Capacidade máxima: <strong>{{stay.max_guests}} hóspede{{'s' if stay.max_guests != 1 else ''}}</strong></p>
          <p>Cidade: <strong>{{stay.city}}</strong></p>
      </aside>
  </div>
</div>
