% rebase('layout', title='Admin - Reservas')

<style>
    .admin-list-container { max-width: 1100px; margin: 30px auto; font-family: "Poppins", sans-serif; }
    .admin-page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; color: #2f1c6a; }
    .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
    .admin-table th { background-color: #2f1c6a; color: white; text-align: left; padding: 15px; font-size: 14px; }
    .admin-table td { padding: 15px; border-bottom: 1px solid #eee; color: #444; font-size: 14px; }
    
    .action-buttons { display: flex; gap: 8px; }
    .btn-sm { padding: 5px 10px; border-radius: 4px; font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; border: 1px solid transparent; }
    
    .btn-edit-sm { background-color: #e3f2fd; color: #1976d2; border-color: #bbdefb; }
    .btn-edit-sm:hover { background-color: #1976d2; color: white; }

    .btn-delete-sm { background-color: #ffeded; color: #d32f2f; border-color: #ffcdd2; }
    .btn-delete-sm:hover { background-color: #d32f2f; color: white; }

    .status-badge { padding: 3px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; background: #e3fcef; color: #006644; text-transform: uppercase;}
    .back-link { color: #2f1c6a; text-decoration: none; font-weight: 600; }
</style>

<div class="admin-list-container">
    <div class="admin-page-header">
        <h1>📅 Gerenciar Reservas</h1>
        <a href="/admin" class="back-link">← Voltar ao Painel</a>
    </div>

    % if bookings:
    <table class="admin-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Stay</th>
                <th>Hóspede</th>
                <th>Período</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
        % for b in bookings:
            <tr>
                <td>#{{b.id}}</td>
                <td>Stay #{{b.stay_id}}</td>
                <td>
                    % guest = users_by_id.get(b.guest_id) 
                    {{guest.name if guest else b.guest_id}}
                </td>
                <td>{{fmt_date(b.check_in)}} <br> {{fmt_date(b.check_out)}}</td>
                <td><span class="status-badge">{{b.status}}</span></td>
                <td>
                    <div class="action-buttons">
                        <a href="/bookings/edit/{{b.id}}" class="btn-sm btn-edit-sm">Editar</a>
                        
                        <form action="/admin/bookings/delete/{{b.id}}" method="post" onsubmit="return confirm('Cancelar esta reserva?');" style="margin:0;">
                            <button type="submit" class="btn-sm btn-delete-sm">Cancelar</button>
                        </form>
                    </div>
                </td>
            </tr>
        % end
        </tbody>
    </table>
    % else:
        <div style="text-align: center; padding: 40px; background: white; border-radius: 8px; color: #666;">
            Nenhuma reserva encontrada.
        </div>
    % end
</div>