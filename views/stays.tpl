% rebase('layout', title='Stays')

<style>
    body {
        background-color: #ffffff;
        
    }
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
    }
    .page-header h1 {
        margin: 0;
    }
    .page-header .actions a {
        margin-left: 10px;
        text-decoration: none;
        color: #2f1c6a;
        font-weight: bold;
    }
    .filter-box {
        background: #fafbff;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 20px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        max-width: 320px;
        color: #2f1c6a
    }
    .filter-box h3 {
        margin-top: 0;
        margin-bottom: 10px;
        font-size: 18px;
    }
    .filter-section-title {
        margin: 10px 0 5px;
        font-weight: bold;
        font-size: 14px;
    }
    .filter-box label {
        font-size: 13px;
    }
    .filter-actions {
        margin-top: 10px;
    }
    .btn-primary {
        background-color: #2f1c6a;
        color: #fafbff;
        border: none;
        border-radius: 4px;
        padding: 6px 12px;
        cursor: pointer;
    }
    .btn-secondary-link {
        margin-left: 8px;
        font-size: 13px;
        text-decoration: none;
        color: #2f1c6a;
    }
    .stays-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        margin-top: 10px;
        padding: 0;
        list-style: none;
    }
    .stay-card {
        background: #fafbff;
        border-radius: 8px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.12);
        padding: 10px;
        width: 340px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        position: relative;
    }
    .favorite-heart {
        position: absolute;
        top: 12px;
        right: 12px;
        z-index: 2;
    }
    .favorite-heart button {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        border: none;
        background-color: #ffffff;
        box-shadow: 0 1px 4px rgba(0,0,0,0.3);
        cursor: pointer;
        font-size: 18px;
        line-height: 32px;
        text-align: center;
        color: #2f1c6a;
        padding: 0;
    }
    .stay-card img {
        width: 100%;
        height: 300px;
        object-fit: cover;
        border-radius: 6px;
        flex-shrink: 0;
    }
    .stay-right {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        flex: 1;
    }
    .stay-info {
        font-size: 13px;
    }
    .stay-title {
        font-weight: bold;
        font-size: 15px;
        margin-bottom: 2px;
        color: #2f1c6a
    }
    .stay-meta {
        color: #8176a6;
        margin-bottom: 2px;
    }
    .stay-rating {
        font-size: 12px;
        margin-top: 4px;
        color: #2f1c6a
    }
    .stay-rating .stars {
        color: #2f1c6a;    
        font-size: 25px;  
    }
    .stay-rating .acceptance-text {
        color: #2f1c6a;  
        font-size: 17px;
    }

    .stay-footer {
        margin-top: 6px;
        background-color: #2f1c6a;
        border-radius: 6px;
        padding: 4px 6px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #fafbff;
    }
    .stay-actions-left {
        display: flex;
        gap: 4px;
        align-items: center;
    }
    .stay-actions-left a,
    .stay-actions-left button {
        font-size: 12px;
        padding: 3px 8px;
        border-radius: 3px;
        border: none;
        background-color: #fafbff;
        color: #2f1c6a;
        cursor: pointer;
        text-decoration: none;
    }
    .stay-actions-left form { 
        margin: 0; 
    }

    .stay-actions-right button {
        font-size: 13px;
        padding: 6px 14px;
        border-radius: 4px;
        border: none;
        background-color: #4caf50;
        color: #fafbff;
        font-weight: bold;
        cursor: pointer;
    }

    .stay-actions-right form { 
        margin: 0; 
    }

</style>

<div class="page-header">
    <h1>{{'Meus stays' if defined('my_stays') and my_stays else 'Stays'}}</h1>
    <div class="actions">
        % if defined('my_stays') and my_stays:
            <a href="/stays">Procurar stays</a>
        % else:
            <a href="/my-stays">Meus stays</a>
        % end
        <a href="/stays/add">Cadastrar nova stay</a>
        <a href="/favorites">Favoritos</a>
    </div>
</div>

<div style="display: flex; gap: 20px; align-items: flex-start; flex-wrap: wrap;">
    <div class="filter-box">
        % if not (defined('my_stays') and my_stays):
            <h3>Filtros</h3>
            <form method="get" action="/stays">
                <div>
                    <label for="city" class="filter-section-title">Cidade</label><br>
                    <input type="text" id="city" name="city" value="{{city or ''}}" style="width: 100%; padding: 4px;">
                </div>

                <div class="filter-section-title">Comodidades</div>
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

                <div class="filter-section-title">Nota média</div>
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
                </label><br>

                <div class="filter-actions">
                    <button type="submit" class="btn-primary">Buscar</button>
                    <a href="/stays" class="btn-secondary-link">Limpar filtros</a>
                </div>
            </form>
        % end
    </div>

    <ul class="stays-grid">
    % for stay in stays:
        % media = ratings_by_stay.get(stay.id) if defined('ratings_by_stay') else None
        % taxa = acceptance_by_stay.get(stay.id) if defined('acceptance_by_stay') else None
        % filled_stars = int(media) if media is not None else 0

        <li class="stay-card">

            <form class="favorite-heart" action="/stays/{{stay.id}}/favorite" method="post">
                <button type="submit">❤</button>
            </form>

            <img src="/static/img/stays/{{stay.image_filename}}" alt="Imagem da stay">
            <div class="stay-right">
                <div class="stay-info">
                    <div class="stay-title">{{stay.title}}</div>
                    <div class="stay-meta">{{stay.city}} -  R$ {{f"{stay.price_per_night:.2f}"}} / noite</div>
                    <div class="stay-meta">Máx hóspedes: {{stay.max_guests}}</div>

                    <div class="stay-rating">
                        % if media is not None:
                            <span class="stars">
                                % for i in range(filled_stars):
                                    ★
                                % end
                                % for i in range(5 - filled_stars):
                                    ☆
                                % end
                            </span>
                        % else:
                            <span class="no-reviews">Nota média: (sem reviews)</span>
                        % end
                        <br>
                        <span class="acceptance-text">
                            % if taxa is not None:
                                Taxa de aceitação: {{taxa}}%
                            % else:
                                Taxa de aceitação: (sem dados)
                            % end
                        </span>
                    </div>
                </div>

                <div class="stay-footer">
                    <div class="stay-actions-left">
                        <a href="/stays/{{stay.id}}">Detalhes</a>
                        <a href="/stays/{{stay.id}}/reviews">Reviews</a>
                    </div>
                    <div class="stay-actions-right">
                        <form action="/bookings/add/{{stay.id}}" method="get">
                            <button type="submit">Alugar</button>
                        </form>
                    </div>
                </div>
            </div>
        </li>

    % end
    </ul>
</div>
