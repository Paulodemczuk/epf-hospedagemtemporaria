% rebase('layout', title='Favoritos')

<h1>Favoritos do usuário {{user_id}}</h1>

<p><a href="/stays">Voltar para Stays</a></p>

% if favorite_stays:
    <ul>
    % for stay in favorite_stays:
        <li>
            <strong>{{stay.title}}</strong> - {{stay.city}} - R$ {{stay.price_per_night}} / noite
            <br>
            Máx hóspedes: {{stay.max_guests}}
            <br>
            <form action="/stays/{{stay.id}}/favorite" method="post" style="display:inline;">
                <input type="hidden" name="user_id" value="{{user_id}}">
                <button type="submit">Remover dos favoritos</button>
            </form>
            <a href="/stays/{{stay.id}}">Exibir informações</a>
        </li>
    % end
    </ul>
% else:
    <p>Você ainda não tem stays favoritas.</p>
% end
