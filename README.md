# Aplicação de Gerenciamento de Tarefas e Lembretes

##### Entregas Obrigatórias:
- Lucas Almeida Braz - Universidade Salvador - RA 1272322938
- [Link de download do apk](https://drive.google.com/file/d/1oWdiPEsLrufKO_G4_NRRvYsLkCYx_kNa/view?usp=drive_link)
- [Link do vídeo demonstrativo]()
- [Link do documento PDF]()

### Descrição
Essa aplicação é um sistema de gerenciamento de tarefas e lembretes desenvolvido em Flutter. Ela permite que os usuários criem, editem e gerenciem suas tarefas e lembretes de forma eficiente.

### Componentes da Aplicação
**TaskManager**
É a página principal da aplicação, responsável por exibir a lista de tarefas e lembretes do usuário, por exibir Dialogs e por redirecionar para as demais páginas. 

**TaskList**
É um widget que exibe a lista de tarefas do usuário. Ele permite que o usuário selecione, edite e exclua tarefas.

**ReminderList**
É um widget que exibe a lista de lembretes do usuário. Ele permite que o usuário selecione, edite e exclua lembretes.

**SideMenu**
É um widget que exibe um menu lateral. Ele permite que o usuário acesse a página de edição de dados cadastrais, altere o tema da aplicação, e faça o logout.

**Task**
É um modelo de dados que representa uma tarefa. Ele contém propriedades como nome, descrição, data e hora de vencimento, etc.

**Reminder**
É um modelo de dados que representa um lembrete. Ele contém propriedades como nome, descrição, data e hora de vencimento, etc.

**Notify**
É um serviço que gerencia as notificações da aplicação. Ele é responsável por exibir notificações para o usuário quando um lembrete está próximo de vencer.

### Funcionalidades da Aplicação
**Criar e editar Usuários**: É possível cadastrar usuários e editar os seus dados cadastrais.
**Criar Tarefas e Lembretes**: O usuário pode criar novas tarefas e lembretes fornecendo informações como nome, descrição, data e hora de vencimento.
**Editar Tarefas e Lembretes**: O usuário pode editar tarefas e lembretes existentes alterando suas propriedades.
**Excluir Tarefas e Lembretes**: O usuário pode excluir tarefas e lembretes que não são mais necessários.
**Selecionar Tarefas e Lembretes**: O usuário pode selecionar tarefas e lembretes para visualizar mais informações ou realizar ações específicas.
**Marcar ou desmarcar tarefas como concluídas**: O usuário pode marcar ou desmarcar tarefas como concluídas.
**Filtrar Tarefas e Lembretes**: O usuário pode filtrar tarefas por nome, descrição ou categoria e filtrar lembretes por nome ou descrição. 
**Alterar tema**: O usuário pode livremente alterar entre tema claro e escuro.
**Notificações**: A aplicação exibe notificações para o usuário quando um lembrete está próximo de vencer.
### Tecnologias Utilizadas
**Flutter**: É o framework utilizado para desenvolver a aplicação.
**Dart**: É a linguagem de programação utilizada para desenvolver a aplicação.
**Http**: É um pacote utilizado para gerenciar requisições HTTP.
**Provider**: É um pacote utilizado para gerenciar o estado da aplicação.
**Flutter Local Notifications**: É um pacote utilizado para gerenciar as notificações da aplicação.
**Permission Handler**: É um pacote utilizado para gerenciar status de premições de usuário.
**Flutter Secure Storage**: É um pacote utilizado para gerenciar armazenamento em cache de forma segura.
### Instalação e Execução
**Passos para Instalar e Executar**
1. Clone o repositório da aplicação.
2. Instale as dependências necessárias executando o comando flutter pub get.
3. Execute a aplicação utilizando o comando flutter run.
### Contribuição
Se você deseja contribuir para a aplicação, por favor, siga os passos abaixo:

1. Faça um fork do repositório da aplicação.
2. Crie uma branch para sua contribuição.
3. Faça as alterações necessárias.
4. Envie um pull request para o repositório original.
### Licença
A aplicação é licenciada sob a licença MIT.