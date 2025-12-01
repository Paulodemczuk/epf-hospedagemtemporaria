% rebase('layout', title='Feature')

<h1>{{'Editar feature' if feature else 'Nova feature'}}</h1>

<form method="post" action="{{action}}">
    <label>Nome:<br>
        <input type="text" name="name" value="{{feature.name if feature else ''}}" required>
    </label><br><br>

    <label>Ícone (opcional):<br>
        <input type="text" name="icon" value="{{feature.icon if feature else ''}}">
    </label><br><br>

    <button type="submit">Salvar</button>
    <a href="/features">Voltar</a>
</form>
