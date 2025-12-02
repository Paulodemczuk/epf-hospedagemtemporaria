% rebase('layout', title='Seja Premium')

<div style="text-align: center; padding: 50px;">
    <h1 style="color: #f1c40f;">👑 Torne-se Premium</h1>
    <p>Tenha acesso a benefícios exclusivos e economize em todas as viagens!</p>

    <div style="border: 2px solid #f1c40f; padding: 30px; max-width: 400px; margin: 30px auto; border-radius: 10px;">
        <h2>Plano Viajante VIP</h2>
        <ul style="list-style: none; padding: 0;">
            <li>✅ <strong>15% de desconto</strong> em todas as reservas</li>
            <li>✅ Suporte prioritário</li>
            <li>✅ Badge exclusivo no perfil</li>
        </ul>
        <h3>R$ 29,90 / mês</h3>
        
        % if current_user and current_user.is_premium:
            <div style="background: #d4edda; color: #155724; padding: 10px; margin-top: 20px;">
                Você já é Premium! 🌟
            </div>
            <form action="/premium/subscribe" method="post" style="margin-top: 10px;">
                <button type="submit" style="background: #ccc; border: none; padding: 10px 20px; cursor: pointer;">Cancelar Assinatura</button>
            </form>
        % else:
            <form action="/premium/subscribe" method="post" style="margin-top: 20px;">
                <button type="submit" style="background: #f1c40f; color: #333; font-weight: bold; border: none; padding: 15px 30px; font-size: 18px; cursor: pointer; border-radius: 5px;">
                    ASSINAR AGORA
                </button>
            </form>
        % end
    </div>
</div>