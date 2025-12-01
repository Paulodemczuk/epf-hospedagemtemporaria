% rebase('layout', title='Stays')

<h1>{{'Meus stays' if defined('my_stays') and my_stays else 'Stays'}}</h1>

<p>
    % if defined('my_stays') and my_stays:
        <a href="/stays">Procurar stays</a> |
    % else:
        <a href="/my-stays">Meus stays</a> |
    % end
    <a href="/stays/add">Cadastrar nova stay</a> |
    <a href="/favorites">Ver favoritos</a>
</p>

<form method="get" action="/stays">
    % if not (defined('my_stays') and my_stays):
        <label for="city">Filtrar por cidade:</label>
        <input type="text" id="city" name="city" value="{{city or ''}}">
        <button type="submit">Buscar</button>
    % end
</form>

<ul>
% for stay in stays:
    % media = ratings_by_stay.get(stay.id) if defined('ratings_by_stay') else None
    % taxa = acceptance_by_stay.get(stay.id) if defined('acceptance_by_stay') else None
    <li>
        <img src="/static/img/stays/{{stay.image_filename}}" style="width: 150px; height: 100px; object-fit: cover; border-radius: 5px; float: left; margin-right: 15px;">

        <strong>{{stay.title}}</strong> - {{stay.city}} - R$ {{stay.price_per_night}} / noite
        <br>
        Máx hóspedes: {{stay.max_guests}}
        <br>
        % if media is not None:
            Nota média: {{media}} / 5
        % else:
            Nota média: (sem reviews)
        % end
        <br>
        % if taxa is not None:
            Taxa de aceitação: {{taxa}}%
        % else:
            Taxa de aceitação: (sem dados)
        % end
        <br>

        <a href="/stays/{{stay.id}}">Exibir informações</a> |

        <a href="/stays/edit/{{stay.id}}">Editar</a>
        <form action="/stays/delete/{{stay.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>

        <form action="/bookings/add/{{stay.id}}" method="get" style="display:inline;">
            <button type="submit">Alugar</button>
        </form>

        <form action="/stays/{{stay.id}}/reviews" method="get" style="display:inline;">
            <button type="submit">Reviews</button>
        </form>

        <form action="/stays/{{stay.id}}/favorite" method="post" style="display:inline;">
            <button type="submit">Favorito</button>
        </form>
    </li>
    <br style="clear: both;">
% end
</ul>
