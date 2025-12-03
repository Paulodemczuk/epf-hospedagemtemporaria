# UnBnB - Sistema de Hospedagem Temporária - 2025.2

## Sobre o projeto
O UnBnB é um sistema de hospedagem temporária, permitindo que os usuarios criem anuncios (stays) de estadias e aluguem o local desejado.

Alem de alugar e listar imoveis, os usuarios podem favoritar locais, fazer reviews, "assinar" um plano premium para receber descontos.

### Usuario
* Cadastro e login: Podem se cadastrar (Autenticação com hashing de senhas).
* Plano Premium: Podem assinar o plano vip para obter descontos nas reservas.

### Stays (Hospedagens)
* Anuncios: Stays podem ser criadas, editadas listadas e excluidas.
* Imagens: Podem ser feito o upload de imagens para ilustrar o anuncio (uma imagem padrao esta definida caso nao aja upload de uma imagem)
* Filtros: Buscas por cidade, features (Wifi, Piscina, etc) e nota de avaliação.
* Reviews: Sistema de avaliação (de 1 a 5 estrelas) com comentarios e média calculada automaticamente.

### Reservas (Bookings)
* Sistema de Validação: o sistema impede conflito de datas e excesso de hospedes.
* Preço: Calculo automatico do valor da estadia com base nas diarias.

### Painel Administrativo
* Acesso exclusivo para administradores.
* Gerenciamento global de usuários, reservas e estadias.

## Usuario Admin
Para acessar o Painel Administrativo é possivel acessar o login de admin a partir de:
* E-mail: admin@admin.com
* Senha: ADMIN

## Diagrama de Classes

<img src="UnBnb/static/img/diagrama.png"  width=1200px alt="imagem do diagrama de classes" title="Diagrama de Classes">

## Instruções de instalação/execução

1. Clone o repositório ou extraia os arquivos:
```bash
git clone https://github.com/Paulodemczuk/epf-hospedagemtemporaria/tree/main
cd unbnb
```

2. Crie o ambiente virtual na pasta fora do seu projeto:
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\\Scripts\\activate     # Windows
```

3. Entre dentro do seu projeto criado a partir do template e instale as dependências:
```bash
pip install -r requirements.txt
```

4. Rode a aplicação:
```bash
python main.py
```

5. Accese sua aplicação no navegador em: [http://localhost:8080](http://localhost:8080)

---