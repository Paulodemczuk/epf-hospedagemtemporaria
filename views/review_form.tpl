% rebase('layout', title='Review')

<h1>{{'Editar review' if review else 'Nova review'}}</h1>

<p>Stay: {{stay.title if stay else 'Stay ' + str(stay_id)}}</p>

<form method="post" action="{{action}}">

    <label for="rating">Nota (1 a 5):</label><br>
    <input type="number" id="rating" name="rating" min="1" max="5"
           value="{{review.rating if review else '5'}}" required><br><br>

    <label>Você recomenda?</label><br>
    % recomendo = None
    % if review:
    %     recomendo = 'sim' if getattr(review, 'recomenda', True) else 'nao'
    % end
    <label>
        <input type="radio" name="recomenda" value="sim"
               {{'checked' if not review or recomendo == 'sim' else ''}}>
        Recomendo
    </label>
    <label>
        <input type="radio" name="recomenda" value="nao"
               {{'checked' if recomendo == 'nao' else ''}}>
        Não recomendo
    </label>
    <br><br>

    <label for="comment">Comentário:</label><br>
    <textarea id="comment" name="comment" rows="4" cols="40">{{review.comment if review else ''}}</textarea><br><br>

    <button type="submit">Salvar</button>
    <a href="/stays/{{stay_id}}/reviews">Voltar</a>
</form>
