% rebase('layout', title='Stay')

<h1>{{'Editar stay' if stay else 'Nova stay'}}</h1>

<form method="post" action="{{action}}" enctype="multipart/form-data">
    <label for="title">Título:</label><br>
    <input type="text" id="title" name="title"
           value="{{stay.title if stay else ''}}" required><br><br>

    <label for="city">Cidade:</label><br>
    <input type="text" id="city" name="city"
           value="{{stay.city if stay else ''}}" required><br><br>

    <label for="price_per_night">Preço por noite:</label><br>
    <input type="number" step="0.01" id="price_per_night" name="price_per_night"
           value="{{stay.price_per_night if stay else ''}}" required><br><br>

    <label for="max_guests">Máx hóspedes:</label><br>
    <input type="number" id="max_guests" name="max_guests" min="1"
           value="{{stay.max_guests if stay else '1'}}" required><br><br>

    <div style="margin-bottom: 20px; border: 1px solid #ddd; padding: 10px; border-radius: 5px;">
        <label>Imagem da Hospedagem:</label><br>
        
        % if stay and stay.image_filename and stay.image_filename != 'default.jpg':
            <div style="margin: 10px 0;">
                <img src="/static/img/stays/{{stay.image_filename}}" alt="Foto Atual" style="max-width: 200px; border-radius: 4px;">
                <br><small style="color: #666;">Imagem atual</small>
            </div>
        % end

        <input type="file" name="image_file" accept="image/png, image/jpeg, image/jpg">
        <br><small>Formatos aceitos: JPG, PNG</small>
    </div>


    <h3>Comodidades / Tipo</h3>
    % selected = set(stay.features_ids) if stay else set()
    % for f in features:
        <label>
            <input type="checkbox" name="features_ids" value="{{f.id}}"
                {{'checked' if f.id in selected else ''}}>
            {{f.name}}
        </label><br>
    % end

    <br>
    <button type="submit">Salvar</button>
    <a href="/stays">Voltar</a>
</form>
