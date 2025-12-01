% rebase('layout', title='Reservas')

<h1>Reservas</h1>

<p><a href="/stays">Voltar para Stays</a></p>

<ul>
% for b in bookings:
    % nome_stay = stay_by_id[b.stay_id].title if b.stay_id in stay_by_id else 'Stay ' + str(b.stay_id)
    <li>
        ID {{b.id}} – {{nome_stay}} – Hóspede {{b.guest_id}} –
        {{b.check_in}} até {{b.check_out}} – Total: R$ {{b.total_price}} – Status: {{b.status}}
        <br>
        <a href="/bookings/edit/{{b.id}}">Editar</a>
        <form action="/bookings/delete/{{b.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>
