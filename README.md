Sistema de Gerenciamento de Eventos Acadêmicos desenvolvido para a disciplina de Paradigmas de Linguagens de Programação.


    👥 Integrantes do Grupo

-


    🛠 Arquitetura e Stack Tecnológica:
Este sistema vai ser construído como uma aplicação web completa utilizando:

Linguagem/Framework: Elixir + Phoenix Framework (focado em alta concorrência e tolerância a falhas).
Banco de Dados: PostgreSQL (para transações complexas e consultas com joins/agregações).
Proxy Reverso: Nginx (configurado para balanceamento de carga e serviço de arquivos estáticos/uploads).
Tempo Real: Phoenix Channels/LiveView para notificações e chat ao vivo.


🚀 Funcionalidades Implementadas
O sistema pretende atender aos seguintes requisitos do projeto:

Autenticação: Sistema de login com papéis diferenciados para Aluno, Palestrante e Admin.
Gestão de Eventos: Criação de eventos, controle rigoroso de vagas para evitar overbooking e geração de certificados em PDF.
Recursos Real-time: Chat interativo durante palestras e notificações de lotação.
Dashboards: Visualização gráfica da ocupação dos eventos e relatórios por departamento.
Busca Avançada: Implementação de busca full-text no banco de dados.


📂 Como Executar o Projeto
