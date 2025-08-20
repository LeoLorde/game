import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/database/dao/loja_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:game/presentation/screens/store_screen/bloc/store_state.dart';
import 'package:game/presentation/screens/store_screen/bloc/store_event.dart';

class LojaBloc extends Bloc<LojaEvent, LojaState> {
  LojaDao? lojaDao;

  LojaBloc() : super(LojaLoading()) {
    on<LojaStarted>((event, emit) async {
      emit(LojaLoading());
      try {
        await _initDb();
        final lista = await lojaDao?.buscarTodos() ?? [];
        emit(LojaSuccess(lista));
      } catch (e) {
        emit(LojaError(e.toString()));
      }
    });

    on<LojaUpdated>((event, emit) async {
      emit(LojaLoading());
      try {
        final lista = await lojaDao?.buscarTodos() ?? [];
        emit(LojaSuccess(lista));
      } catch (e) {
        emit(LojaError(e.toString()));
      }
    });
  }

  Future<void> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'game.db');
    final db = await openDatabase(path);
    lojaDao = LojaDao(db);
  }

  Future<void> comprarItem(int id) async {
    if (lojaDao != null) {
      await lojaDao!.comprarItem(id);
      add(LojaUpdated());
    }
  }
}
