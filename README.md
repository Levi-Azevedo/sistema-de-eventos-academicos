🎓 Sistema de Gerenciamento de Eventos AcadêmicosProjeto prático para a disciplina de Paradigmas de Linguagens de Programação.👥 GrupoIntegrante 1 (Seu Nome)Integrante 2Integrante 3Integrante 4Integrante 5(Total de 5 alunos conforme a regra do projeto).🛠 Stack TecnológicaLinguagem: Elixir.Framework Web: Phoenix.Banco de Dados: PostgreSQL.Proxy Reverso: Nginx.🚀 Guia de Instalação (Para os Colegas)Siga estes passos para configurar o ambiente de desenvolvimento local:1. Pré-requisitosAntes de clonar, você precisa ter instalado:Erlang/OTP (v26 ou superior).Elixir (v1.16 ou superior).PostgreSQL ativo na máquina.2. Configuração InicialApós clonar o repositório, execute os seguintes comandos no terminal:PowerShell# 1. Instalar o gerador do Phoenix (caso não tenha)
mix archive.install hex phx_new

# 2. Instalar as dependências do projeto
mix deps.get
3. Configuração do Banco de DadosAbra o arquivo config/dev.exs.Altere as linhas de username e password para as credenciais do seu PostgreSQL local.No terminal, crie o banco:PowerShellmix ecto.create
4. Rodando o ProjetoPara iniciar o servidor:PowerShellmix phx.server
Acesse no navegador: http://localhost:4000📌 Funcionalidades a DesenvolverConforme o roteiro do projeto:Autenticação: Diferentes papéis (Aluno, Palestrante, Admin).Gestão: Inscrições com controle de vagas e geração de certificados em PDF.Real-time: Chat ao vivo (Phoenix Channels) e notificações de lotação.Relatórios: Dashboards de ocupação e exportação em CSV.Infra: Configuração de Nginx como proxy reverso.⚖️ LicençaEste projeto está sob a Licença MIT.
