% rebase('layout', title='Reservas')

<style>
  .bookings-container {
      max-width: 800px;
      margin: 0 auto;
  }
  .bookings-header {
      margin-bottom: 15px;
  }
  .bookings-header h1 {
      margin: 0;
      font-size: 24px;
  }
  .bookings-list {
      list-style: none;
      padding: 0;
      margin: 0;
      display: flex;
      flex-direction: column;
      gap: 10px;
  }
  .booking-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 20px 24px;
      font-size: 20px;
      color: #2f1c6a;
  }
  .booking-top {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 4px;
  }
  .booking-stay-title {
      font-weight: bold;
      font-size: 22px;
  }
  .booking-meta {
      font-size: 14px;
      color: #555;
  }
  .booking-dates {
      margin-top: 4px;
  }
  .booking-total {
      margin-top: 4px;
      font-weight: bold;
  }
  .booking-actions {
      margin-top: 6px;
      display: flex;
      gap: 6px;
  }
  .btn-booking {
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
  .btn-booking.delete {
      background-color: #b3261e;
  }
  .booking-actions form {
      display: inline;
      margin: 0;
  }

  .no-bookings {
      text-align: center;
      padding: 60px 20px;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.05);
      border: 1px dashed #ccc;
  }
  .no-bookings h3 {
      color: #2f1c6a;
      margin-bottom: 10px;
  }
  .no-bookings p {
      color: #666;
      margin-bottom: 25px;
  }
</style>

<div class="bookings-container">
  <div class="bookings-header">
      <h1>Minhas reservas</h1>
  </div>

  % if bookings:
      <ul class="bookings-list">
      % for b in bookings:
          % stay = stay_by_id.get(b.stay_id)
          <li class="booking-card">
              <div class="booking-top">
                  <span class="booking-stay-title">
                      {{stay.title if stay else 'Stay ' + str(b.stay_id)}}
                  </span>
                  <span>Status: {{b.status}}</span>
              </div>

              <div class="booking-dates">
                  {{b.check_in}} até {{b.check_out}}
              </div>

              <div class="booking-meta">
                  Reserva #{{b.id}} – Hóspede: {{user.name if user else 'Usuário ' + str(b.guest_id)}}
              </div>

              <div class="booking-total">
                  Total: R$ {{f"{b.total_price:.2f}"}}
              </div>

              <div class="booking-actions">
                  <a href="/bookings/edit/{{b.id}}" class="btn-booking">Editar</a>
                  <form action="/bookings/delete/{{b.id}}" method="post">
                      <button type="submit" class="btn-booking delete">Excluir</button>
                  </form>
              </div>
          </li>
      % end
      </ul>
  % else:
      <div class="no-bookings">
          <h3>Você ainda não possui reservas :(</h3>
          <p>Que tal encontrar o lugar perfeito para sua próxima viagem?</p>
          <a href="/stays" class="btn-booking">Explorar Hospedagens</a>
      </div>
  % end
</div>