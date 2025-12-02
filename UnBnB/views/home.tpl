% rebase('layout', title='Início')

<style>
  body {
      background-color: #fafbff;
  }

  .home_header {
      max-width: 600px;
      margin: 200px auto 20px auto; 
      font-family: "Poppins", sans-serif;
      color: #2f1c6a;
      text-align: center;
      font-size: 30px;
  }

  .home_grid {
      text-align: center;       
      margin-bottom: 40px;
  }

  .btn-login-box {
      display: inline-block;
      padding: 10px 24px;
      border-radius: 8px;
      background-color: #2f1c6a;
      color: #fafbff;
      text-decoration: none;
      font-size: 25px;
      font-weight: 600;
      box-shadow: 0 1px 4px rgba(0,0,0,0.1);
  }

  .btn-login-box:hover {
      filter: brightness(1.05);
  }
</style>

<div class="home_container">
  <div class="home_header">
      <h1>Bem-vindo ao UnBnB!</h1>
      <p>Encontre o lugar perfeito para sua estadia temporária.</p>
  </div>

  <div class="home_grid">
      <a href="/entrar" class="btn-login-box">Entrar</a>
  </div>
</div>
