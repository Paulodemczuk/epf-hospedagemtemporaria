% rebase('layout', title='Detalhes da Stay')

<h1>{{stay.title}}</h1>

<p>Cidade: {{stay.city}}</p>
<p>Preço por noite: R$ {{f"{stay.price_per_night:.2f}"}}</p>
<p>Máx hóspedes: {{stay.max_guests}}</p>
<p>Anfitrião: </b> {{host.name if host else 'Desconhecido'}}</p>

<h3>Comodidades</h3>
% if features:
    <ul>
    % for f in features:
        <li>{{f.name}}</li>
    % end
    </ul>
% else:
    <p>Nenhuma comodidade cadastrada.</p>
% end

<p>
    <a href="/stays">Voltar para Stays</a> |
    <a href="/stays/{{stay.id}}/reviews">Ver reviews</a> |
    <a href="/bookings/add/{{stay.id}}">Fazer reserva</a>
</p>
