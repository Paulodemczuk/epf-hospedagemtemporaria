% rebase('layout', title='Admin - Stays')

<style>
    .admin-list-container { max-width: 1000px; margin: 30px auto; font-family: "Poppins", sans-serif; }
    .admin-page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; color: #2f1c6a; }
    .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .admin-table th { background-color: #2f1c6a; color: white; text-align: left; padding: 15px; }
    .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: #444; vertical-align: middle; }
    
    .action-buttons { display: flex; gap: 8px; }
    .btn-sm { padding: 5px 10px; border-radius: 4px; font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
    
    .btn-edit-sm { background-color: #e3f2fd; color: #1976d2; border-color: #bbdefb; }
    .btn-edit-sm:hover { background-color: #1976d2; color: white; }

    .btn-delete-sm { background-color: #ffeded; color: #d32f2f; border-color: #ffcdd2; }
    .btn-delete-sm:hover { background-color: #d32f2f; color: white; }

    .stay-thumb { width: 50px; height: 50px; border-radius: 4px; object-fit: cover; margin-right: 10px; vertical-align: middle; }
    .back-link { color: #2f1c6a; text-decoration: none; font-weight: 600; }
</style>

<div class="admin-list-container">
    <div class="admin-page-header">
        <h1>🏡 Gerenciar Stays</h1>
        <a href="/admin" class="back-link">← Voltar ao Painel</a>
    </div>

    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Hospedagem</th>
                <th>Localização</th>
                <th>Preço</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
        % for s in stays:
            <tr>
                <td>#{{s.id}}</td>
                <td>
                    % img = s.image_filename if hasattr(s, 'image_filename') and s.image_filename else 'default.jpg'
                    <img src="/static/img/stays/{{img}}" class="stay-thumb">
                    <strong>{{s.title}}</strong>
                </td>
                <td>{{s.city}}</td>
                <td>R$ {{f"{s.price_per_night:.2f}"}}</td>
                <td>
                    <div class="action-buttons">
                        <a href="/stays/edit/{{s.id}}" class="btn-sm btn-edit-sm">Editar</a>
                        
                        <form action="/admin/stays/delete/{{s.id}}" method="post" onsubmit="return confirm('Tem certeza?');" style="margin:0;">
                            <button type="submit" class="btn-sm btn-delete-sm">Excluir</button>
                        </form>
                    </div>
                </td>
            </tr>
        % end
        </tbody>
    </table>
</div>