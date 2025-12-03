% rebase('layout', title='Admin - Relatórios')

<style>
    .admin-container { max-width: 1100px; margin: 40px auto; font-family: "Poppins", sans-serif; }
    
    .page-header {
        display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;
    }
    .page-header h1 { margin: 0; color: #2f1c6a; }
    
    .back-link {
        color: #2f1c6a; text-decoration: none; font-weight: 600;
        border: 1px solid #2f1c6a; padding: 8px 16px; border-radius: 6px;
        transition: all 0.2s;
    }
    .back-link:hover { background-color: #2f1c6a; color: white; }

    .charts-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
        gap: 20px;
    }

    .chart-card {
        background: white; padding: 25px; border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08); text-align: center;
        border: 1px solid #eee;
    }
    .chart-card h2 { font-size: 18px; margin-bottom: 20px; color: #2f1c6a; }
    .chart-card img { max-width: 100%; height: auto; border-radius: 4px; }
    .no-data { padding: 40px; color: #666; font-style: italic; }
</style>

<div class="admin-container">
    <div class="page-header">
        <h1>📊 Relatórios de Performance</h1>
        <a href="/admin" class="back-link">← Voltar ao Painel</a>
    </div>

    <div class="charts-grid">
        
        <div class="chart-card">
            <h2>💰 Faturamento Mensal</h2>
            % if defined('earnings_chart') and earnings_chart:
                <img src="data:image/png;base64,{{earnings_chart}}" alt="Gráfico Financeiro">
            % else:
                <div class="no-data">Sem dados de reservas confirmadas.</div>
            % end
        </div>

        <div class="chart-card">
            <h2>🏙️ Distribuição Geográfica</h2>
            % if defined('stays_chart') and stays_chart:
                <img src="data:image/png;base64,{{stays_chart}}" alt="Gráfico de Cidades">
            % else:
                <div class="no-data">Nenhum stay cadastrado.</div>
            % end
        </div>

    </div>
</div>