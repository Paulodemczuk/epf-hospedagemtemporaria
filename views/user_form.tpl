% rebase('layout', title='Formulário Usuário')

<style>
  .user-form-container {
      max-width: 600px;
      margin: 40px auto;
      font-family: "Poppins", sans-serif;
  }

  .user-form-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      padding: 30px;
      color: #2f1c6a;
      border: 1px solid #eee;
  }

  .user-form-card h1 {
      margin-top: 0;
      font-size: 28px;
      margin-bottom: 20px;
      text-align: center;
      color: #2f1c6a;
  }

  .user-form-group {
      margin-bottom: 20px;
  }

  .user-form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      font-size: 14px;
      color: #2f1c6a;
  }

  .user-form-group input[type="text"],
  .user-form-group input[type="email"],
  .user-form-group input[type="date"],
  .user-form-group input[type="password"] {
      width: 100%;
      padding: 10px 12px;
      border-radius: 6px;
      border: 1px solid #ccc;
      font-family: inherit;
      font-size: 15px;
      box-sizing: border-box;
      transition: border-color 0.2s;
  }

  .user-form-group input:focus {
      border-color: #2f1c6a;
      outline: none;
  }

  .password-hint {
      font-size: 12px;
      color: #666;
      margin-top: 5px;
      display: block;
  }

  .user-form-actions {
      margin-top: 30px;
      display: flex;
      gap: 15px;
      justify-content: flex-end;
  }

  .btn-save {
      background-color: #2f1c6a;
      color: white;
      border: none;
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: background-color 0.2s;
  }

  .btn-save:hover {
      background-color: #1a0f3c;
  }

  .btn-cancel {
      background-color: #fff;
      color: #666;
      border: 1px solid #ddd;
      padding: 10px 20px;
      border-radius: 6px;
      font-size: 16px;
      text-decoration: none;
      transition: background-color 0.2s;
  }

  .btn-cancel:hover {
      background-color: #f5f5f5;
      color: #333;
  }
</style>

<div class="user-form-container">
    <div class="user-form-card">
        <h1>{{'Editar Usuário' if user else 'Adicionar Usuário'}}</h1>
        
        <form action="{{action}}" method="post">
            
            <div class="user-form-group">
                <label for="name">Nome Completo</label>
                <input type="text" id="name" name="name" required 
                       value="{{user.name if user else ''}}" placeholder="Ex: João da Silva">
            </div>
            
            <div class="user-form-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" required 
                       value="{{user.email if user else ''}}" placeholder="Ex: joao@email.com">
            </div>
            
            <div class="user-form-group">
                <label for="birthdate">Data de Nascimento</label>
                <input type="date" id="birthdate" name="birthdate" required 
                       value="{{user.birthdate if user else ''}}">
            </div>

            <div class="user-form-group">
                <label for="password">Senha</label>
                <input type="password" id="password" name="password" 
                       {{'required' if not user else ''}} placeholder="********">
                
                % if user:
                    <span class="password-hint">* Deixe em branco para manter a senha atual.</span>
                % end
            </div>
            
            <div class="user-form-actions">
                <a href="/admin/users" class="btn-cancel">Cancelar</a>
                <button type="submit" class="btn-save">Salvar Alterações</button>
            </div>
        </form>
    </div>
</div>