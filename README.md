🎓 Sistema de Gerenciamento de Eventos Acadêmicos
Projeto prático desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.
👥 Equipe e Papéis

Integrante 1:
Integrante 2:
Integrante 3:
Integrante 4: 
Integrante 5: 

🛠 Stack Tecnológica
A aplicação utiliza uma stack moderna focada em alta concorrência e performance:
Backend: Elixir + Phoenix Framework.
Banco de Dados: PostgreSQL (Consultas complexas e busca full-text).
Servidor Web: Nginx como Proxy Reverso.
Tempo Real: Phoenix Channels para Chat e Notificações.

🚀 Como Rodar o Projeto 
1. Pré-requisitos
Certifique-se de ter instalado em sua máquina:
Erlang/OTP 28+
Elixir 1.18+
PostgreSQL rodando localmente.
2. Configuração do Ambiente
Após clonar o repositório, execute os comandos abaixo na raiz do projeto:

`# Instalar o gerador do Phoenix (apenas na primeira vez)
mix archive.install hex phx_new

# Baixar as dependências do Elixir
mix deps.get

# Instalar dependências do Assets (se necessário)
cd assets && npm install && cd .. `
3. Configuração do Banco de DadosAbra o arquivo config/dev.exs.Edite as credenciais do PostgreSQL (username e password).Crie o banco de dados executando:PowerShellmix ecto.create
4. InicializaçãoPara subir o servidor Phoenix:PowerShellmix phx.server
Acesse: http://localhost:4000📋 Funcionalidades PlanejadasAutenticação: Níveis de acesso para Aluno, Palestrante e Admin.Gestão: Inscrições com controle de vagas e certificados em PDF.Real-time: Chat interativo durante eventos e alertas de lotação.Relatórios: Dashboards de ocupação e exportação de dados (CSV/PDF).📄 LicençaEste projeto está sob a licença MIT.
