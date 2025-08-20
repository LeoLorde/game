import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/core/models/deck_model.dart';
import 'package:flutter/material.dart';
import 'bot_event.dart';
import 'bot_state.dart';
import 'package:game/core/classes/bot_ai.dart';

class BotBloc extends Bloc<BotEvent, BotState> {
  BotBloc() : super(BotOnLoading()) {
    on<BotOnStart>(_onStart);
    on<BotOnUpdate>(_onUpdate);
  }

  // Quando o jogo começa → cria o deck do bot e carrega as criaturas
  Future<void> _onStart(BotOnStart event, Emitter<BotState> emit) async {
    emit(BotOnLoading());

    try {
      // cria deck do bot
      debugPrint("0/3 - Criando Deck do Bot");
      final deckBot = await createBotDeck();

      // pega todas as criaturas do banco
      debugPrint("1/3 - Pegando Todas as Criaturas");
      final todasCriaturas = await getTodasCriaturas();

      // filtra só as que estão no deck do bot
      debugPrint("2/3 - Selecionando Criaturas");
      final criaturasDoBot = todasCriaturas
          .where((c) => deckBot.cardIds.contains(c.id))
          .toList();
      debugPrint("3/3 - Carregou");
      emit(BotOnSuccess(criaturasDoBot));
    } catch (e) {
      emit(BotOnError('Erro ao carregar deck do Bot: $e'));
    }
  }

  Future<void> _onUpdate(BotOnUpdate event, Emitter<BotState> emit) async {
    try {
      final deckBot = await createBotDeck();
      final todasCriaturas = await getTodasCriaturas();

      final criaturasDoBot = todasCriaturas
          .where((c) => deckBot.cardIds.contains(c.id))
          .toList();

      emit(BotOnSuccess(criaturasDoBot));
    } catch (e) {
      emit(BotOnError('Erro ao atualizar estado do Bot: $e'));
    }
  }
}
