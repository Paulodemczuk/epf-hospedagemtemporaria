% rebase('layout', title='Reserva')

% from bottle import request
% error = request.query.get('error')

<style>
  .booking-form-container {
      max-width: 600px;
      margin: 0 auto;
  }
  .booking-form-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 14px 16px;
      font-size: 20px;
      color: #2f1c6a;
  }
  .booking-form-card h1 {
      margin-top: 0;
      font-size: 30px;
      margin-bottom: 10px;
  }
  .booking-form-stay {
      font-size: 18px;
      margin-bottom: 10px;
  }
  .booking-error {
      background: #ffdddd;
      color: #a94442;
      padding: 10px;
      margin-bottom: 15px;
      border: 1px solid #ebccd1;
      border-radius: 4px;
      font-size: 14px;
  }
  .booking-form-group {
      margin-bottom: 10px;
  }
  .booking-form-group label {
      display: block;
      margin-bottom: 4px;
      font-weight: bold;
  }
  .booking-form-group input[type="number"],
  .booking-form-group input[type="date"] {
      width: 100%;
      padding: 6px;
      border-radius: 4px;
      border: 1px solid #ccc;
      font-family: inherit;
      font-size: 17px;
  }
  .booking-form-actions {
      margin-top: 10px;
      display: flex;
      gap: 8px;
  }
  .btn-primary-booking,
  .btn-primary-booking:link,
  .btn-primary-booking:visited {
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
  .btn-secondary-booking,
  .btn-secondary-booking:link,
  .btn-secondary-booking:visited {
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

<div class="booking-form-container">
  <div class="booking-form-card">
      <h1>{{'Editar reserva' if booking else 'Nova reserva'}}</h1>

      <p class="booking-form-stay">
          Stay: {{stay.title if stay else 'Stay ' + str(stay_id)}}
      </p>

      % if error:
          <div class="booking-error">
              {{error}}
          </div>
      % end

      <form method="post" action="{{action}}">
          <input type="hidden" name="stay_id" value="{{stay.id}}">

          <div class="booking-form-group">
              <label for="guests_count">Quantidade de hóspedes</label>
              <input type="number" id="guests_count" name="guests_count"
                     min="1"
                     value="{{booking.guests_count if booking and hasattr(booking, 'guests_count') else '1'}}">
          </div>

          <div class="booking-form-group">
              <label for="check_in">Check-in</label>
              <input type="date" id="check_in" name="check_in"
                     value="{{booking.check_in if booking else ''}}">
          </div>

          <div class="booking-form-group">
              <label for="check_out">Check-out</label>
              <input type="date" id="check_out" name="check_out"
                     value="{{booking.check_out if booking else ''}}">
          </div>

          <div class="booking-form-actions">
              <button type="submit" class="btn-primary-booking">
                  {{'Salvar alterações' if booking else 'Confirmar reserva'}}
              </button>
              <a href="/bookings" class="btn-secondary-booking">Cancelar</a>
          </div>
      </form>
  </div>
</div>
