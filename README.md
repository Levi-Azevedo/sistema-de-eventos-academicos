<h1>🎓 Sistema de Gerenciamento de Eventos Acadêmicos</h1>
  Projeto prático desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.
<h3>👥 Equipe e Papéis</h3>

- Integrante 1:

- Integrante 2:

- Integrante 3:

- Integrante 4: 

- Integrante 5: 

<h3>🛠 Stack Tecnológica</h3>
A aplicação utiliza uma stack moderna focada em alta concorrência e performance:

- Backend: Elixir + Phoenix Framework.

- Banco de Dados: PostgreSQL (Consultas complexas e busca full-text).

- Servidor Web: Nginx como Proxy Reverso.

- Tempo Real: Phoenix Channels para Chat e Notificações.

<h3>🚀 Como Rodar o Projeto</h3> 
<h4> 1. Pré-requisitos: </h4>
Certifique-se de ter instalado em sua máquina:

 + Erlang/OTP 28+
 
 + Elixir 1.18+
 
 + PostgreSQL rodando localmente.

<h4>2. Configuração do Ambiente: </h4>

Após clonar o repositório, execute os comandos abaixo na raiz do projeto:

~~~
#Instalar o gerador do Phoenix (apenas na primeira vez)
mix archive.install hex phx_new

#Baixar as dependências do Elixir
mix deps.get
~~~

<h4>3. Configuração do Banco de Dados</h4>
  
- Abra o arquivo config/dev.exs.

- Edite as credenciais do PostgreSQL (username e password) para as credenciais do seu PostgreSQL.

- Crie o banco de dados executando:
~~~
mix ecto.create
~~~
<h4>4. Inicialização</h4>

Para subir o servidor Phoenix: 
~~~
mix phx.server
~~~
Acesse: http://localhost:4000


<h3>📋 Funcionalidades Planejadas</h3>

- Autenticação: Níveis de acesso para Aluno, Palestrante e Admin.

- Gestão: Inscrições com controle de vagas e certificados em PDF.

- Real-time: Chat interativo durante eventos e alertas de lotação.

- Relatórios: Dashboards de ocupação e exportação de dados (CSV/PDF).

<h3>📄 Licença:</h3>

Este projeto está sob a licença MIT.
