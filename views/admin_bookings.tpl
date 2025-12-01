% rebase('layout', title='Admin - Reservas')

<h1>Todas as reservas</h1>

<ul>
% for b in bookings:
    <li>
        ID {{b.id}} – Stay {{b.stay_id}} – Hóspede {{b.guest_id}} –
        {{b.check_in}} até {{b.check_out}} – Total: R$ {{b.total_price}} – Status: {{b.status}}
        <form action="/admin/bookings/delete/{{b.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>

<p><a href="/admin">Voltar</a></p>
