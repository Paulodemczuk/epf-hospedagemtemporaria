<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap">
    <title>{{title or 'Hospedagem Temporária'}}</title>
    <style>
        body { font-family: "Poppins", sans-serif; margin: 20px; }
        nav a { margin-right: 10px; }
        h1 { margin-top: 0; }
    </style>
</head>
<body>

<style>
    .top-nav {
        background-color: #2f1c6a;
        color: #fafbff;
        padding: 8px 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-family: "Poppins", sans-serif;
        font-size: 25px;
    }
    .top-nav a {
        color: #fafbff;
        text-decoration: none;
        margin-right: 12px;
    }
    .top-nav a:hover {
        text-decoration: underline;
    }
    .nav-left a:last-child {
        margin-right: 0;
    }
    .nav-right {
        display: flex;
        align-items: center;
        gap: 20px;
    }
    .nav-hello {
        opacity: 0.9;
    }
</style>


<nav class="top-nav">
    <div class="nav-left">
        <a href="/stays">Stays</a>
        <a href="/bookings">Reservas</a>
    </div>

    <div class="nav-right">
        % if defined('current_user') and current_user:
            <span class="nav-hello">Olá, {{current_user.name}}!</span>
            % if getattr(current_user, 'role', 'user') == 'admin':
                <a href="/admin">Admin</a>
            % end
            <a href="/logout">Logout</a>
        % else:
            <a href="/login">Login</a>
        % end
    </div>
</nav>
<hr>

<hr>

{{!base}}

</body>
</html>
