% rebase('layout', title='Stays')

<h1>Stays</h1>

<p><a href="/stays/add">Cadastrar nova stay</a></p>

<form method="get" action="/stays">
    <label for="city">Filtrar por cidade:</label>
    <input type="text" id="city" name="city" value="{{city or ''}}">
    <button type="submit">Buscar</button>
</form>

<ul>
% for stay in stays:
    <li>
        <strong>{{stay.title}}</strong> - {{stay.city}} - R$ {{stay.price_per_night}} / noite
        <br>
        Máx hóspedes: {{stay.max_guests}}
        <br>
        <a href="/stays/edit/{{stay.id}}">Editar</a>
        <form action="/stays/delete/{{stay.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>

        <!-- Botão para reservar (alugar) esta stay -->
        <form action="/bookings/add/{{stay.id}}" method="get" style="display:inline;">
            <button type="submit">Alugar</button>
        </form>
    </li>
% end
</ul>
