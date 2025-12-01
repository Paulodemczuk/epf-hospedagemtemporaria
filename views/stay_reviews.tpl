% rebase('layout', title='Reviews')

<h1>Reviews para {{stay.title if stay else 'Stay ' + str(stay.id)}}</h1>

<p><a href="/stays">Voltar para Stays</a></p>

<ul>
% for r in reviews:
    <li>
        Nota: {{r.rating}}<br>
        % if r.comment and r.comment.strip():
            Comentário: {{r.comment}}<br>
        % end
        Usuário ID: {{r.user_id}}
        <br>
        <a href="/reviews/edit/{{r.id}}">Editar</a>
        <form action="/reviews/delete/{{r.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>

<p>
    <a href="/stays/{{stay.id}}/reviews/add">Adicionar review</a>
</p>
