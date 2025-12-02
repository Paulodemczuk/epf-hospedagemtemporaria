% rebase('layout', title='Reservas')

<h1>Minhas Reservas</h1>

% if defined('user') and user:
    <p>Usuário: {{user.name}}</p>
% end

<p><a href="/stays">Voltar para Stays</a></p>

<ul>
% for b in bookings:
    % stay = stay_by_id.get(b.stay_id)
    <li>
        Reserva {{b.id}} – {{stay.title if stay else 'Stay ' + str(b.stay_id)}} –
        Hóspede: {{user.name if user else 'Usuário ' + str(b.guest_id)}} –
        {{b.check_in}} até {{b.check_out}} – Total: R$ {{f"{b.total_price:.2f}"}} –
        Status: {{b.status}}
        <br>
        <a href="/bookings/edit/{{b.id}}">Editar</a>
        <form action="/bookings/delete/{{b.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>
