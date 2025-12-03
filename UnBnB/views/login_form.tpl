% rebase('layout', title='Login')

<style>
  .login-container {
      max-width: 400px;
      margin: 60px auto;
      font-family: "Poppins", sans-serif;
      color: #2f1c6a;
  }
  .login-card {
      background: #fafbff;
      border-radius: 8px;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
      padding: 18px 20px;
  }
  .login-card h2 {
      margin-top: 0;
      margin-bottom: 12px;
      font-size: 22px;
  }
  .login-form-group {
      margin-bottom: 10px;
  }
  .login-form-group label {
      display: block;
      margin-bottom: 4px;
      font-weight: 500;
  }
  .login-form-group input {
      width: 100%;
      padding: 8px;
      border-radius: 4px;
      border: 1px solid #ccc;
      font-family: inherit;
      font-size: 14px;
      box-sizing: border-box;
  }
  .login-error {
      background: #ffdddd;
      color: #a94442;
      padding: 10px;
      margin-bottom: 12px;
      border: 1px solid #ebccd1;
      border-radius: 4px;
      font-size: 13px;
  }
  .btn-login {
      margin-top: 16px;
      width: 100%;
      padding: 8px;
      border-radius: 4px;
      border: none;
      background-color: #2f1c6a;
      color: #fafbff;
      font-size: 15px;
      cursor: pointer;
  }
</style>

<div class="login-container">
  <div class="login-card">
      % if defined('error') and error:
          <div class="login-error">
              {{error}}
          </div>
      % end

      <h2>Entre com a sua conta</h2>

      <form action="/login" method="post">
          <div class="login-form-group">
              <label for="email">Email</label>
              <input type="email" id="email" name="email" required>
          </div>

          <div class="login-form-group">
              <label for="password">Senha</label>
              <input type="password" id="password" name="password" required>
          </div>

          <button type="submit" class="btn-login">Entrar</button>
      </form>

      <p style="margin-top: 12px; font-size: 13px;">
          Não tem conta? <a href="/users/add">Cadastre-se</a>
      </p>
  </div>
</div>
