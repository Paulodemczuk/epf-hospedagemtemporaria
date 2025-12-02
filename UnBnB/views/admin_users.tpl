% rebase('layout', title='Admin - Usuários')

<style>
    .admin-list-container { max-width: 1000px; margin: 30px auto; font-family: "Poppins", sans-serif; }
    .admin-page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; color: #2f1c6a; }
    .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .admin-table th { background-color: #2f1c6a; color: white; text-align: left; padding: 15px; font-weight: 500; }
    .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: #444; }
    
    .badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
    .badge-admin { background: #e0daff; color: #2f1c6a; }
    .badge-user { background: #eee; color: #666; }
    
    .action-buttons { display: flex; gap: 8px; align-items: center; }
    
    .btn-sm {
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
        text-decoration: none;
        display: inline-block;
        border: 1px solid transparent;
        transition: all 0.2s;
    }

    .btn-edit-sm {
        background-color: #e3f2fd;
        color: #1976d2;
        border-color: #bbdefb;
    }
    .btn-edit-sm:hover { background-color: #1976d2; color: white; }

    .btn-delete-sm {
        background-color: #ffeded;
        color: #d32f2f;
        border-color: #ffcdd2;
    }
    .btn-delete-sm:hover { background-color: #d32f2f; color: white; }

    .back-link { color: #2f1c6a; text-decoration: none; font-weight: 600; }
</style>

<div class="admin-list-container">
    <div class="admin-page-header">
        <h1>👥 Gerenciar Usuários</h1>
        <a href="/admin" class="back-link">← Voltar ao Painel</a>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Email</th>
                <th>Função</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
        % for u in users:
            <tr>
                <td>#{{u.id}}</td>
                <td><strong>{{u.name}}</strong></td>
                <td>{{u.email}}</td>
                <td>
                    % role = getattr(u, 'role', 'user')
                    <span class="badge {{'badge-admin' if role == 'admin' else 'badge-user'}}">
                        {{role}}
                    </span>
                </td>
                <td>
                    <div class="action-buttons">
                        <a href="/users/edit/{{u.id}}" class="btn-sm btn-edit-sm">Editar</a>

                        % if u.id != 0 and getattr(u, 'role', 'user') != 'admin':
                            <form action="/admin/users/delete/{{u.id}}" method="post" onsubmit="return confirm('Tem certeza?');" style="margin:0;">
                                <button type="submit" class="btn-sm btn-delete-sm">Excluir</button>
                            </form>
                        % end
                    </div>
                </td>
            </tr>
        % end
        </tbody>
    </table>
</div>