<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{'Editar' if stay else 'Nova'}} Stay</title>
</head>
<body>
    <h1>{{'Editar' if stay else 'Nova'}} Stay</h1>

    <form method="post" action="{{action}}">
        <label for="title">Título:</label><br>
        <input type="text" id="title" name="title" value="{{stay.title if stay else ''}}" required><br><br>

        <label for="description">Descrição:</label><br>
        <textarea id="description" name="description">{{stay.description if stay else ''}}</textarea><br><br>

        <label for="city">Cidade:</label><br>
        <input type="text" id="city" name="city" value="{{stay.city if stay else ''}}" required><br><br>

        <label for="price_per_night">Preço por noite:</label><br>
        <input type="number" step="0.01" id="price_per_night" name="price_per_night"
               value="{{stay.price_per_night if stay else ''}}" required><br><br>

        <label for="max_guests">Máx. hóspedes:</label><br>
        <input type="number" id="max_guests" name="max_guests"
               value="{{stay.max_guests if stay else ''}}" required><br><br>

        <button type="submit">Salvar</button>
    </form>

    <p><a href="/stays">Voltar</a></p>
</body>
</html>
