<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <title>{{title or 'Hospedagem Temporária'}}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        nav a { margin-right: 10px; }
        h1 { margin-top: 0; }
    </style>
</head>
<body>

<nav>
    <a href="/stays">Stays</a>
    <a href="/my-stays">Meus Stays</a>
    <a href="/favorites">Favoritos</a>
    <a href="/bookings">Reservas</a>

    % if defined('current_user') and current_user and getattr(current_user, 'role', 'user') == 'admin':
        <a href="/admin">Admin</a>
    % end

    % if defined('current_user') and current_user:
        <span>Olá, {{current_user.name}}</span>
        <a href="/logout">Logout</a>
    % else:
        <a href="/login">Login</a>
    % end
</nav>

<hr>

{{!base}}

</body>
</html>
