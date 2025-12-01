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
        <input type="text" id="city" name="city" value="{{city or ''}}"><br><br>

        <h4>Filtrar por comodidades:</h4>
        % selected_feats = set(selected_features) if defined('selected_features') else set()
        % if defined('all_features'):
            % for f in all_features:
                <label>
                    <input type="checkbox" name="features_ids" value="{{f.id}}"
                           {{'checked' if f.id in selected_feats else ''}}>
                    {{f.name}}
                </label><br>
            % end
        % end

        <h4>Filtrar por nota:</h4>
        % selected_ranges = set(selected_rating_ranges) if defined('selected_rating_ranges') else set()
        <label>
            <input type="checkbox" name="rating_range" value="0-1"
                   {{'checked' if '0-1' in selected_ranges else ''}}>
            0 a 1 estrela
        </label><br>
        <label>
            <input type="checkbox" name="rating_range" value="1-2"
                   {{'checked' if '1-2' in selected_ranges else ''}}>
            1 a 2 estrelas
        </label><br>
        <label>
            <input type="checkbox" name="rating_range" value="2-3"
                   {{'checked' if '2-3' in selected_ranges else ''}}>
            2 a 3 estrelas
        </label><br>
        <label>
            <input type="checkbox" name="rating_range" value="3-4"
                   {{'checked' if '3-4' in selected_ranges else ''}}>
            3 a 4 estrelas
        </label><br>
        <label>
            <input type="checkbox" name="rating_range" value="4-5"
                   {{'checked' if '4-5' in selected_ranges else ''}}>
            4 a 5 estrelas
        </label><br>
        <label>
            <input type="checkbox" name="rating_range" value="5-5"
                   {{'checked' if '5-5' in selected_ranges else ''}}>
            Apenas 5 estrelas
        </label><br><br>

        <button type="submit">Buscar</button>
        <a href="/stays" style="margin-left: 10px;">Limpar filtros</a>
    % end
</form>

<ul>
% for stay in stays:
    % media = ratings_by_stay.get(stay.id) if defined('ratings_by_stay') else None
    % taxa = acceptance_by_stay.get(stay.id) if defined('acceptance_by_stay') else None
    <li>
        <img src="/static/img/stays/{{stay.image_filename}}"
             style="width: 150px; height: 100px; object-fit: cover; border-radius: 5px; float: left; margin-right: 15px;">

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
