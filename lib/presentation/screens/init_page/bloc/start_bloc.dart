import 'package:flutter_bloc/flutter_bloc.dart';
import 'player_repository.dart';
import 'start_event.dart';
import 'start_state.dart';

class StartPageBloc extends Bloc<StartEvent, StartState> {
  final PlayerRepository playerRepository;

  StartPageBloc(this.playerRepository) : super(StartOnLoading()) {
    on<StartOnStart>(_onStart);
    on<StartOnUpdate>(_onUpdate);
    on<StartAdicionarAmuletos>(_onAdicionarAmuletos);
  }

  Future<void> _onStart(StartOnStart event, Emitter<StartState> emit) async {
    emit(StartOnLoading());
    try {
      final player = await playerRepository.getPlayer();
      emit(StartOnSuccess(
        player.amuletos,
        player.cristais,
        player.level,
        player.nickName,
      ));
    } catch (e) {
      emit(StartOnError(e.toString()));
    }
  }

  Future<void> _onUpdate(StartOnUpdate event, Emitter<StartState> emit) async {
    try {
      final player = await playerRepository.getPlayer();
      emit(StartOnSuccess(
        player.amuletos,
        player.cristais,
        player.level,
        player.nickName,
      ));
    } catch (e) {
      emit(StartOnError(e.toString()));
    }
  }

  Future<void> _onAdicionarAmuletos(
      StartAdicionarAmuletos event, Emitter<StartState> emit) async {
    try {
      await playerRepository.adicionarAmuletos(event.quantidade);
      final player = await playerRepository.getPlayer();
      emit(StartOnSuccess(
        player.amuletos,
        player.cristais,
        player.level,
        player.nickName,
      ));
    } catch (e) {
      emit(StartOnError(e.toString()));
    }
  }
}
