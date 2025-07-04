# Testes #

Esta pasta contém os testes automatizados do projeto. Eles garantem o funcionamento correto dos modelos, classes e funcionalidades principais do jogo.

## Como rodar os testes ##

Todos os testes (mesmo em diferentes arquivos) serão rodados quando executar o seguinte comando:

> **Dart puro**

```bash
dart test
```

> **Flutter junto**

```bash
flutter test
```

## Como Criar os Testes ##

Mantenha na mesma estrutura de arquivos que aparece no /lib, mas com a diferença que os arquivos devem ter o sufixo "_test.dart", além de testarem casos que são prováveis de dar erro:

- Casos Limites
- Casos Normais
- Dados Inválidos

## Por Que Criar Testes ##

Para quando houver uma alteração inesperada, ou com um código aparentemente inofensivo causar efeitos colaterais indesejados em outra parte do sistema, afinal tudo está interligado. Esses testes automatizados vão encontrar todos os erros e ajudar a resolver problemas de forma mais rápida e eficiente que apenas nós olhando as linhas de código.

Isso claro, além de ajudar a garantir que o jogo está seguindo a lógica do GDD, facilitando com a continuação do projeto e mantendo tudo interligado.

Um exemplo é: Imagine que um dia alguém altere a fórmula de cálculo de dano sem entender que ela depende da média entre os elementos da criatura inimiga. Sem testes, essa alteração passa despercebida — e o jogo começa a aplicar dano errado. Com os testes ele iria identificar isso de forma rápida. Apenas com um comando no terminal.
