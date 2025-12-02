% rebase('layout', title='Checkout')

<div style="max-width: 600px; margin: 0 auto; padding: 20px;">
    <h1>Resumo da Reserva</h1>
    
    <div style="border: 1px solid #ddd; padding: 15px; border-radius: 8px; margin-bottom: 20px; background: #f9f9f9;">
        <h3>{{summary['stay'].title}}</h3>
        <p>📍 {{summary['stay'].city}}</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p><strong>Entrada:</strong> {{summary['check_in']}}</p>
        <p><strong>Saída:</strong> {{summary['check_out']}}</p>
        <p><strong>Duração:</strong> {{summary['nights']}} noite(s)</p>
        <hr>
        <p>Diária: R$ {{f"{summary['price_per_night']:.2f}"}}</p>
        <h2 style="color: #2f1c6a;">Total: R$ {{f"{summary['total']:.2f}"}}</h2>
    </div>

    <div style="background: #eee; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
        <h4>💳 Pagamento (Simulação)</h4>
        <input type="text" placeholder="Número do Cartão (Fake)" style="width: 100%; padding: 8px; margin-bottom: 10px;">
        <div style="display: flex; gap: 10px;">
            <input type="text" placeholder="MM/AA" style="width: 50%; padding: 8px;">
            <input type="text" placeholder="CVV" style="width: 50%; padding: 8px;">
        </div>
    </div>

    <form action="/bookings/confirm" method="post">
        <input type="hidden" name="stay_id" value="{{summary['stay'].id}}">
        <input type="hidden" name="check_in" value="{{summary['check_in']}}">
        <input type="hidden" name="check_out" value="{{summary['check_out']}}">
        <input type="hidden" name="guests_count" value="{{guests_count}}">
        
        <button type="submit" style="width: 100%; padding: 15px; background: #2ecc71; color: white; border: none; font-size: 18px; font-weight: bold; cursor: pointer; border-radius: 5px;">
            Confirmar e Pagar
        </button>
    </form>
    
    <br>
    <a href="/bookings/add/{{summary['stay'].id}}" style="color: #666;">← Voltar e alterar datas</a>
</div>