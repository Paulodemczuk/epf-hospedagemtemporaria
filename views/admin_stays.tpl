% rebase('layout', title='Admin - Stays')

<h1>Todas as stays</h1>

<ul>
% for s in stays:
    <li>
        ID {{s.id}} – {{s.title}} – {{s.city}} – R$ {{s.price_per_night}} / noite
        <form action="/admin/stays/delete/{{s.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>

<p><a href="/admin">Voltar</a></p>
