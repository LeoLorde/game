import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_event.dart';
import 'battle_state.dart';
import 'package:game/core/classes/battle.dart';
import 'package:game/core/classes/bot_ai.dart';
import 'package:game/core/models/attack_model.dart';
import 'package:game/core/models/creature_model.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  Map<Creature, int> playerDeck = {};
  Map<Creature, int> botDeck = {};
  late MapEntry<Creature, int> playerCreature;
  late MapEntry<Creature, int> botCreature;
  bool playerTurn = true;

  BattleBloc() : super(BattleLoading()) {
    on<BattleStarted>(_onBattleStarted);
    on<BattleUpdated>(_onBattleUpdated);
    on<PlayerActionEvent>(_onPlayerAction);
    on<PlayerChangeCreature>(_onPlayerChangeCreature); // novo
  }

  Future<void> _onBattleStarted(
      BattleStarted event, Emitter<BattleState> emit) async {
    try {
      emit(BattleLoading());

      playerDeck = await deckJogador();
      botDeck = await deckBotMap();

      playerCreature = playerDeck.entries.first;
      botCreature = botDeck.entries.first;

      playerTurn = (DateTime.now().millisecondsSinceEpoch % 2 == 0);

      emit(BattleStartState(
        playerDeck.keys.toList(),
        botDeck.keys.toList(),
      ));

      if (!playerTurn) await _botTurn(emit);
    } catch (e) {
      emit(BattleError('Erro ao iniciar batalha: $e'));
    }
  }

  Future<void> _onBattleUpdated(
      BattleUpdated event, Emitter<BattleState> emit) async {
    emit(BattleSuccess(
      playerDeck.keys.toList(),
      botDeck.keys.toList(),
      playerCreature.key..vida = playerCreature.value,
    ));
  }

  Future<void> _onPlayerAction(
      PlayerActionEvent event, Emitter<BattleState> emit) async {
    if (!playerTurn) return;

    if (event.action is Attack) {
      final ataqueEscolhido = event.action as Attack;
      botCreature = MapEntry(
        botCreature.key,
        ataque(ataqueEscolhido, botCreature.key, botCreature.value),
      );
    } else if (event.action is int) {
      playerCreature = await alterarCriatura(event.action as int);
    }

    if (botCreature.value <= 0) {
      emit(BattleSuccess(
        playerDeck.keys.toList(),
        botDeck.keys.toList(),
        playerCreature.key..vida = playerCreature.value,
      ));
      return;
    }

    playerTurn = false;
    await _botTurn(emit);
  }

  Future<void> _onPlayerChangeCreature(
      PlayerChangeCreature event, Emitter<BattleState> emit) async {
    final vidaAtual = playerDeck[event.newCreature] ?? event.newCreature.vida;

    playerCreature = MapEntry(event.newCreature, vidaAtual);

    emit(BattleSuccess(
      playerDeck.keys.toList(),
      botDeck.keys.toList(),
      playerCreature.key..vida = playerCreature.value,
    ));
  }

  Future<void> _botTurn(Emitter<BattleState> emit) async {
    final botAI = await BotAI.criar();

    final acaoBot = botAI.decidirAcao(
      botCreature.key,
      playerCreature.key,
      botDeck,
    );

    if (acaoBot['action'] == 'attack') {
      final Attack ataqueEscolhido = acaoBot['attack'];
      playerCreature = MapEntry(
        playerCreature.key,
        ataque(ataqueEscolhido, playerCreature.key, playerCreature.value),
      );
    } else if (acaoBot['action'] == 'switch') {
      final Creature novaCriatura = acaoBot['creature'];
      final vidaNova = botDeck[novaCriatura] ?? novaCriatura.vida;
      botCreature = MapEntry(novaCriatura, vidaNova);
    }

    playerTurn = true;

    emit(BattleSuccess(
      playerDeck.keys.toList(),
      botDeck.keys.toList(),
      playerCreature.key..vida = playerCreature.value,
    ));
  }
}
