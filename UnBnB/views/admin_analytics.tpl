% rebase('layout', title='Admin - Relatórios')

<style>
    .admin-container {
        max-width: 1000px;
        margin: 40px auto;
        font-family: "Poppins", sans-serif;
    }
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }
    .page-header h1 {
        margin: 0;
        color: #2f1c6a;
    }
    .back-link {
        color: #2f1c6a;
        text-decoration: none;
        font-weight: 600;
        border: 1px solid #2f1c6a;
        padding: 8px 16px;
        border-radius: 6px;
        transition: all 0.2s;
    }
    .back-link:hover {
        background-color: #2f1c6a;
        color: white;
    }
    .chart-card {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        text-align: center;
        border: 1px solid #eee;
    }
    .chart-card img {
        max-width: 100%;
        height: auto;
        border-radius: 4px;
    }
    .no-data {
        padding: 40px;
        color: #666;
        font-style: italic;
    }
</style>

<div class="admin-container">
    <div class="page-header">
        <h1>📊 Relatórios de Performance</h1>
        <a href="/admin" class="back-link">← Voltar ao Painel</a>
    </div>

    <div class="chart-card">
        <h2 style="font-size: 20px; margin-bottom: 25px; color: #2f1c6a;">Faturamento Mensal (Reservas Confirmadas)</h2>
        
        % if chart:
            <img src="data:image/png;base64,{{chart}}" alt="Gráfico de Ganhos Mensais">
        % else:
            <div class="no-data">
                <p>Ainda não há dados suficientes de reservas confirmadas para gerar o gráfico.</p>
                <p>Confirme algumas reservas no sistema para visualizar os dados.</p>
            </div>
        % end
    </div>
</div>