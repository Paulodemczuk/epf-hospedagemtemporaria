% rebase('layout', title='Features')

<h1>Features</h1>

<p><a href="/features/add">Nova feature</a></p>

<ul>
% for f in features:
    <li>
        {{f.id}} - {{f.name}} {{f.icon}}
        <a href="/features/edit/{{f.id}}">Editar</a>
        <form action="/features/delete/{{f.id}}" method="post" style="display:inline;">
            <button type="submit">Excluir</button>
        </form>
    </li>
% end
</ul>
