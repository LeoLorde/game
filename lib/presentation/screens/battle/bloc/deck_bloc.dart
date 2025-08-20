import 'package:flutter_bloc/flutter_bloc.dart';
import 'deck_event.dart';
import 'deck_state.dart';
import 'package:game/core/models/creature_model.dart';
import 'package:game/database/dao/deck_dao.dart';

class DeckBloc extends Bloc<DeckEvent, DeckState> {
  DeckBloc() : super(DeckOnLoading()) {
    on<DeckOnStart>(_onStart);
    on<DeckOnUpdate>(_onUpdate);
  }

  Future<void> _onStart(DeckOnStart event, Emitter<DeckState> emit) async {
    emit(DeckOnLoading());
    try {
      final List<Creature> deck = await getPDeck();
      emit(DeckOnSuccess(deck));
    } catch (e) {
      emit(DeckOnError(e.toString()));
    }
  }

  Future<void> _onUpdate(DeckOnUpdate event, Emitter<DeckState> emit) async {
    try {
      final List<Creature> deck = await getPDeck();
      emit(DeckOnSuccess(deck));
    } catch (e) {
      emit(DeckOnError(e.toString()));
    }
  }
}