import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async'; // <-- NOVO: Necessário para o Timer do turno do bot

import 'package:game/core/classes/battle.dart';
import 'package:game/core/classes/bot_ai.dart';
import 'package:game/core/enums/raridade_enum.dart';
import 'package:game/core/models/attack_model.dart'; // <-- NOVO: Import para o modelo de ataque
import 'package:game/core/models/creature_model.dart';
import 'package:game/application/audio/audio_manager.dart';

class TelaBatalha extends StatefulWidget {
  // A lista de criaturas recebida não é mais necessária, pois o deck é carregado do banco
  const TelaBatalha({super.key, required List<Creature> criaturas});

  @override
  State<TelaBatalha> createState() => _TelaBatalhaState();
}

class _TelaBatalhaState extends State<TelaBatalha> {
  late BotAI bot;

  // Mapas para guardar os decks e a vida atual
  Map<Creature, int> playerDeck = {};
  Map<Creature, int> botDeck = {};

  // Criaturas ativas no campo de batalha
  Creature? playerCreature;
  Creature? botCreature;

  // <-- NOVO: Controle de estado para carregamento e turno
  bool _isLoading = true;
  bool _isPlayerTurn = true;
  String _mensagemStatus = "";

  @override
  void initState() {
    super.initState();
    // <-- MUDANÇA: A inicialização agora é feita de forma segura
    _setupBattle();
    AudioManager.instance.pushBgm('sounds/som/battle1.mp3');
  }

  @override
  void dispose() {
    // <-- NOVO: Garante que a música pare ao sair da tela
    AudioManager.instance.popBgm();
    super.dispose();
  }

  // <-- NOVO: Função central para carregar tudo antes de construir a tela
  Future<void> _setupBattle() async {
    setState(() => _mensagemStatus = "Preparando arena...");

    // Carrega o bot e os decks de forma segura
    bot = await BotAI.criar();
    playerDeck = await deckJogador();
    botDeck = await deckBotMap();

    // Define as criaturas iniciais
    if (playerDeck.isNotEmpty) {
      playerCreature = playerDeck.keys.first;
    }
    if (botDeck.isNotEmpty) {
      botCreature = botDeck.keys.first;
    }

    // <-- NOVO: Sorteia quem começa
    _isPlayerTurn = Random().nextBool();
    _mensagemStatus = _isPlayerTurn ? "Você começa!" : "O oponente começa!";

    // Finaliza o carregamento e atualiza a UI
    setState(() => _isLoading = false);

    // Se o bot começar, ele executa o turno dele após um instante
    if (!_isPlayerTurn) {
      Timer(const Duration(seconds: 2), () => _executarTurnoDoBot());
    }
  }

  // <-- NOVO: Função para o jogador atacar
  void _playerAttack(Attack ataqueEscolhido) {
    if (!_isPlayerTurn || playerCreature == null || botCreature == null) return;

    setState(() {
      _mensagemStatus = "${playerCreature!.name} usa ${ataqueEscolhido.name}!";
      final vidaAtual = botDeck[botCreature] ?? 0;
      final novaVida = ataque(ataqueEscolhido, botCreature!, vidaAtual);
      botDeck[botCreature!] = novaVida;

      if (novaVida <= 0) {
        _mensagemStatus = "${botCreature!.name} do oponente foi derrotado!";
        // Lógica para remover a criatura derrotada e trazer a próxima
      }

      _isPlayerTurn = false;
    });

    // Chama o turno do bot após a ação do jogador
    Timer(const Duration(seconds: 2), () => _executarTurnoDoBot());
  }

  // <-- NOVO: Função para o jogador trocar de criatura
  void _playerSwitch(Creature novaCriatura) {
    if (!_isPlayerTurn) return;

    setState(() {
      _mensagemStatus = "Você trocou para ${novaCriatura.name}!";
      playerCreature = novaCriatura;
      _isPlayerTurn = false;
    });

    // Chama o turno do bot após a troca
    Timer(const Duration(seconds: 2), () => _executarTurnoDoBot());
  }

  // <-- MUDANÇA: Turno do bot agora usa a IA para decidir a ação
  Future<void> _executarTurnoDoBot() async {
    if (botCreature == null || playerCreature == null) return;

    setState(() => _mensagemStatus = "Oponente está pensando...");

    // A IA decide a melhor ação
    final acaoBot = bot.decidirAcao(botCreature!, playerCreature!, botDeck);

    await Future.delayed(
      const Duration(seconds: 2),
    ); // Simula o pensamento do bot

    setState(() {
      if (acaoBot['action'] == 'attack') {
        final Attack ataqueBot = acaoBot['attack'];
        _mensagemStatus = "${botCreature!.name} usa ${ataqueBot.name}!";
        final vidaAtual = playerDeck[playerCreature] ?? 0;
        final novaVida = ataque(ataqueBot, playerCreature!, vidaAtual);
        playerDeck[playerCreature!] = novaVida;

        if (novaVida <= 0) {
          _mensagemStatus = "Seu ${playerCreature!.name} foi derrotado!";
          // Lógica de derrota
        }
      } else if (acaoBot['action'] == 'switch') {
        final Creature novaCriatura = acaoBot['creature'];
        botCreature = novaCriatura;
        _mensagemStatus = "Oponente trocou para ${novaCriatura.name}!";
      }

      _isPlayerTurn = true; // Devolve o turno ao jogador
    });
  }

  // ... (a função corPorRaridade continua a mesma)
  Color corPorRaridade(Raridade raridade) {
    switch (raridade) {
      case Raridade.combatente:
        return Colors.grey.shade300;
      case Raridade.mistico:
        return Colors.orange.shade200;
      case Raridade.heroi:
        return Colors.purple.shade200;
      case Raridade.semideus:
        return Colors.yellow.shade300;
      default:
        return Colors.white;
    }
  }

  // <-- MUDANÇA: O card agora tem uma lógica de clique
  Widget buildCreatureCard(
    Creature creature,
    int currentHP, {
    bool isActive = false,
  }) {
    final cor = corPorRaridade(creature.raridade);

    return SizedBox(
      width: isActive ? 110 : 90, // Maior se estiver ativo
      height: isActive ? 160 : 140,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // <-- NOVO: Destaque visual para o turno do jogador
          side:
              isActive && _isPlayerTurn
                  ? const BorderSide(color: Colors.yellow, width: 3)
                  : const BorderSide(color: Colors.black, width: 2),
        ),
        color: cor,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Text(
                creature.name ?? '???',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Image.asset(
                    creature.getCompletePath(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                'Nv. ${creature.level} | HP: $currentHP',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // <-- NOVO: Mostra os ataques da criatura ativa
  void _showAttackDialog() {
    if (playerCreature == null) return;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Escolha um Ataque', textAlign: TextAlign.center),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playerCreature!.ataques.length,
                itemBuilder: (context, index) {
                  final ataque = playerCreature!.ataques[index];
                  return ListTile(
                    title: Text(ataque.name),
                    subtitle: Text("Poder: ${ataque.base_damage}"),
                    onTap: () {
                      Navigator.of(context).pop();
                      _playerAttack(ataque);
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  // <-- MUDANÇA: Exibe o deck do bot (sem interatividade)
  Widget buildComposicaoBot() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          botDeck.entries.map((entry) {
            final creature = entry.key;
            final hp = entry.value;
            // Não faz nada ao clicar no deck do oponente
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: buildCreatureCard(creature, hp),
            );
          }).toList(),
    );
  }

  // <-- MUDANÇA: Exibe o deck do jogador (com interatividade para troca)
  Widget buildComposicaoPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
          playerDeck.entries.map((entry) {
            final creature = entry.key;
            final hp = entry.value;

            // Permite trocar se a criatura não estiver ativa
            if (creature.id != playerCreature?.id) {
              return GestureDetector(
                onTap: () => _playerSwitch(creature),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: buildCreatureCard(creature, hp),
                ),
              );
            }
            return const SizedBox.shrink(); // Oculta a criatura ativa da "mão"
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _mensagemStatus,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              )
              : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://i.pinimg.com/474x/d5/98/58/d598584bd21317c705cb6e196f974781.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // DECK DO BOT (MÃO)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildComposicaoBot(),
                    ),
                  ),
                  // DECK DO JOGADOR (MÃO)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: buildComposicaoPlayer(),
                    ),
                  ),
                  // <-- NOVO: ÁREA CENTRAL COM CRIATURAS ATIVAS -->
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // CRIATURA ATIVA DO BOT
                        if (botCreature != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: buildCreatureCard(
                              botCreature!,
                              botDeck[botCreature]!,
                              isActive: true,
                            ),
                          ),

                        // MENSAGEM DE STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _mensagemStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // CRIATURA ATIVA DO JOGADOR
                        if (playerCreature != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: GestureDetector(
                              onTap: _isPlayerTurn ? _showAttackDialog : null,
                              child: buildCreatureCard(
                                playerCreature!,
                                playerDeck[playerCreature]!,
                                isActive: true,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
