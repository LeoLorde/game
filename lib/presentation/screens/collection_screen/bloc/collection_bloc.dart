import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/presentation/screens/collection_screen/bloc/collection_state.dart';
import 'package:game/presentation/screens/collection_screen/bloc/collection_event.dart';
import 'package:game/database/dao/collection_dao.dart';

class ColecaoBloc extends Bloc<ColecaoEvent, ColecaoState> {
  ColecaoBloc() : super(ColecaoOnLoading()) {
    on<ColecaoOnStart>(_onStart);
    on<ColecaoOnUpdate>(_onUpdate);
  }

  Future<void> _onStart(
    ColecaoOnStart event,
    Emitter<ColecaoState> emit,
  ) async {
    emit(ColecaoOnLoading());
    try {
      final criaturas = await getCollection();
      emit(ColecaoOnSuccess(criaturas));
    } catch (e) {
      emit(ColecaoOnError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    ColecaoOnUpdate event,
    Emitter<ColecaoState> emit,
  ) async {
    try {
      final criaturas = await getCollection();
      emit(ColecaoOnSuccess(criaturas));
    } catch (e) {
      emit(ColecaoOnError(e.toString()));
    }
  }
}
