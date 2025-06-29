# Creature Card Project #

## Estrutura do Projeto ##

- Core
- - Models (Ou seja, classes / entidades que estarão no jogo), exemplo: Creature;
- - Classes (Outras classes, como batalhas, que não representam nada no Banco de Dados, mas com relação a lógica geral);

- Database
- - Dao (Classes responsáveis por manipular o acesso aos dados persistidos);

- Presentation
- - Screens (Telas completas da aplicação/jogo, que combinam widgets e interagem com a camada Application), exemplo: HomeScreen, StoreScreen, BattleScreen...;
- - Widgets (Widgets personalizados que vamos criar para facilitar a criação da UI), exemplo: CreatureCard.dart;

- Application
- - Controllers (Gerencia os dados recebidos do Dao ou Service e ligam eles com o Presentation. Também faz verificações e validações caso necessário);
- - Services (Misc);
- - Managers (Gerenciadores que cuidam de recursos globais ou compartilhados da aplicação.), exemplo: AudioManager, SettingsManager...;

## Padrão de commits ##

* feat: nova funcionalidade
* fix: correção de bug
* docs: alteração de documentação
* style: formatação (espaços, ponto e vírgula etc)
* refactor: refatoração de código
* test: adição ou modificação de testes
* chore: tarefas sem impacto direto no código (como atualizar dependências)
* build, ci, perf: relacionados a build, CI/CD ou performance
