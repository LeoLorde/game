import 'package:equatable/equatable.dart';

abstract class StartEvent extends Equatable {
  const StartEvent();

  @override
  List<Object?> get props => [];
}

class StartOnStart extends StartEvent {}

class StartOnUpdate extends StartEvent {}

class StartAdicionarAmuletos extends StartEvent {
  final int quantidade;
  const StartAdicionarAmuletos(this.quantidade);

  @override
  List<Object?> get props => [quantidade];
}
