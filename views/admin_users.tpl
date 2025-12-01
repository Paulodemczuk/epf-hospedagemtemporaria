% rebase('layout', title='Admin - Usuários')

<h1>Todos os usuários</h1>

<ul>
% for u in users:
    <li>
        ID {{u.id}} – {{u.name}} – {{u.email}} – role: {{getattr(u, 'role', 'user')}}
        % if u.id != 0:
            <form action="/admin/users/delete/{{u.id}}" method="post" style="display:inline;">
                <button type="submit">Excluir</button>
            </form>
        % end
    </li>
% end
</ul>

<p><a href="/admin">Voltar</a></p>
