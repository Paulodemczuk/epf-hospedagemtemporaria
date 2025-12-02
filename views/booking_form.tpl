% rebase('layout', title='Reserva')

% from bottle import request
% error = request.query.get('error')
% if error:
    <div style="background: #ffdddd; color: #a94442; padding: 10px; margin-bottom: 15px; border: 1px solid #ebccd1; border-radius: 4px;">
        ⚠️ {{error}}
    </div>
% end

<h1>{{'Editar reserva' if booking else 'Nova reserva'}}</h1>

<form method="post" action="/bookings/checkout">
    <p>Stay: {{stay.title if stay else 'Stay ' + str(stay_id)}}</p>

    <input type="hidden" name="stay_id" value="{{stay.id}}">
    <label for="guests_count">Quantidade de hóspedes:</label><br>
    <input type="number" id="guests_count" name="guests_count"
       value="{{booking.guests_count if booking and hasattr(booking, 'guests_count') else '1'}}" min="1"><br><br>

    <label for="check_in">Check-in:</label><br>
    <input type="date" id="check_in" name="check_in"
           value="{{booking.check_in if booking else ''}}"><br><br>

    <label for="check_out">Check-out:</label><br>
    <input type="date" id="check_out" name="check_out"
           value="{{booking.check_out if booking else ''}}"><br><br>

    <button type="submit">Salvar</button>
    <a href="/bookings">Voltar</a>
</form>
