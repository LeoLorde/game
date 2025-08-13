import 'package:equatable/equatable.dart';
import 'package:game/presentation/screens/init_page/bloc/player_repository.dart';
import 'package:game/core/models/creature_model.dart';


abstract class StartState extends Equatable {
  const StartState();

  @override
  List<Object?> get props => [];
}

class StartOnLoading extends StartState {}

class StartOnError extends StartState {
  final String message;
  const StartOnError(this.message);

  @override
  List<Object?> get props => [message];
}

class StartOnSuccess extends StartState {
  final int amuletos;
  final int cristais;
  final int nivel;
  final String name;
  const StartOnSuccess(this.amuletos, this.cristais, this.nivel, this.name);

  @override
  List<Object?> get props => [];
}
