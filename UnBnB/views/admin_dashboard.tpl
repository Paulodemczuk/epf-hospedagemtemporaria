% rebase('layout', title='Admin Dashboard')

<style>
    .admin-container {
        max-width: 1000px;
        margin: 40px auto;
        font-family: "Poppins", sans-serif;
    }
    .admin-header {
        text-align: center;
        margin-bottom: 40px;
        color: #2f1c6a;
    }
    .admin-header h1 {
        font-size: 32px;
        margin-bottom: 10px;
    }
    .admin-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
        gap: 20px;
    }
    .admin-card {
        background: #ffffff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        padding: 30px;
        text-align: center;
        transition: transform 0.2s, box-shadow 0.2s;
        text-decoration: none;
        color: #2f1c6a;
        border: 1px solid #eee;
    }
    .admin-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(47, 28, 106, 0.15);
        border-color: #2f1c6a;
    }
    .card-icon {
        font-size: 40px;
        margin-bottom: 15px;
        display: block;
    }
    .card-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
    }
    .card-desc {
        font-size: 14px;
        color: #666;
    }
</style>

<div class="admin-container">
    <div class="admin-header">
        <h1>Painel Administrativo</h1>
        <p>Gerencie todos os recursos do sistema em um só lugar.</p>
    </div>

    <div class="admin-grid">
        <a href="/admin/users" class="admin-card">
            <span class="card-icon">👥</span>
            <span class="card-title">Gerenciar Usuários</span>
            <span class="card-desc">Visualize, edite ou remova contas de usuários.</span>
        </a>

        <a href="/admin/stays" class="admin-card">
            <span class="card-icon">🏡</span>
            <span class="card-title">Gerenciar Stays</span>
            <span class="card-desc">Controle os anúncios de hospedagem cadastrados.</span>
        </a>

        <a href="/admin/bookings" class="admin-card">
            <span class="card-icon">📅</span>
            <span class="card-title">Gerenciar Reservas</span>
            <span class="card-desc">Monitore todas as reservas feitas no sistema.</span>
        </a>

        <a href="/admin/analytics" class="admin-card">
            <span class="card-icon">📊</span>
            <span class="card-title">Relatórios & Gráficos</span>
            <span class="card-desc">Visualize o faturamento mensal e métricas.</span>
        </a>
    </div>
</div>