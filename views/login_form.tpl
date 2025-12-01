% rebase('layout.tpl', title='Login')

<div class="container" style="max-width: 400px; margin-top: 50px;">
% if defined('error') and error:
        <div style="background: #ffdddd; color: #a94442; padding: 10px; margin-bottom: 15px; border: 1px solid #ebccd1; border-radius: 4px;">
            ⚠️ {{error}}
        </div>
    % end
    <h2>Entrar no Sistema</h2>

    % if defined('error'):
        <div class="alert alert-danger" style="color: red; margin-bottom: 10px;">
            {{error}}
        </div>
    % end

    <form action="/login" method="post">
        <div class="form-group">
            <label>Email:</label>
            <input type="email" name="email" required style="width: 100%; padding: 8px;">
        </div>
        
        <div class="form-group" style="margin-top: 10px;">
            <label>Senha:</label>
            <input type="password" name="password" required style="width: 100%; padding: 8px;">
        </div>

        <button type="submit" class="btn btn-primary" style="margin-top: 20px; width: 100%;">Entrar</button>
    </form>
    
    <p style="margin-top: 15px;">
        Não tem conta? <a href="/users/add">Cadastre-se</a>
    </p>
</div>