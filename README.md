# Creature Card Project #

## Game Design Document ##

É o documento central que reúne todas as informações essenciais sobre o projeto de um jogo. Ele serve como referência para toda a equipe de desenvolvimento (designers, programadores, artistas...) garantindo que todos estejam alinhados em relação à visão, mecânicas, estilo de arte e objetivo final.

Caso você queira saber sobre o nosso projeto de forma mais completa confira ele.

### Objetivo do GDD ###

- Registrar todas as decisões de design do jogo.
- Manter a consistência e coesão entre a equipe.
- Servir como guia durante todo o ciclo de desenvolvimento.
- Facilitar a comunicação e revisão do projeto.

Para mais informações abra o arquivo PDF no Root do projeto: Game_Design_Document.pdf

## Estrutura do Projeto ##

- Core
  - Models (Ou seja, classes / entidades que estarão no jogo), exemplo: Creature;
  - Classes (Outras classes, como batalhas, que não representam nada no Banco de Dados, mas com relação a lógica geral);

- Database
  - Dao (Classes responsáveis por manipular o acesso aos dados persistidos);

- Presentation
  - Screens (Telas completas da aplicação/jogo, que combinam widgets e interagem com a camada Application), exemplo: HomeScreen, StoreScreen, BattleScreen...;
  - Widgets (Widgets personalizados que vamos criar para facilitar a criação da UI), exemplo: CreatureCard.dart;

- Application
  - Controllers (Gerencia os dados recebidos do Dao ou Service e ligam eles com o Presentation. Também faz verificações e validações caso necessário);
  - Services (Misc);
  - Managers (Gerenciadores que cuidam de recursos globais ou compartilhados da aplicação.), exemplo: AudioManager, SettingsManager...;

## Padrão de commits ##

- FEAT: nova funcionalidade
- FIX: correção de bug
- DOCS: alteração de documentação
- STYLE: formatação (espaços, ponto e vírgula etc)
- REFACTOR: refatoração de código
- TEST: adição ou modificação de testes
- CHORE: tarefas sem impacto direto no código (como atualizar dependências)
- BUILD, CI, PERF: relacionados a build, CI/CD ou performance

## Como Contribuir com o Projeto ##

Caso queira contribuir com o projeto e você não é da nossa equipe, siga os seguintes passos:

### 1. Fork e Clone o Repositório ###

- Faça um fork deste repositório.
- Clone o repositório para sua máquina:

```bash
git clone https://github.com/LeoLorde/game
```

Vá para a pasta do projeto:

```bash
cd game
```

### 2. Criando a Branch ###

Antes de QUALQUER modificação, crie uma branch que descreva o que sua contribuição será:

```bash
git checkout -b feat/something
```

Utilize um prefixo que faça sentido com o que você irá fazer / contribuir, verifique no padrão de commits acima quais são eles.

### 3. Modificações ###

Faça suas modificações, mantendo o código limpo, comentado, e caso necessário, atualize a documentação.

### 4. Commit e Push ###

Faça os commits com os prefixos corretos, de forma clara e descritiva:

```bash
git add .
git commit -m "feat: add new sounds"
git push origin sua-branch
```

Lembre-se de manter sua branch alinhada e atualizada com a main do projeto original, para evitar conflitos em um possível Pull Request

### 5. Abra um Pull Request (PR) ###

- Vá até a página do repositório original.
- Clique em "Compare & pull request".
- Descreva suas alterações com clareza.
- Aguarde a revisão e responda aos comentários, se houver.
