import 'package:equatable/equatable.dart';
import 'package:game/core/models/loja_model.dart';

abstract class LojaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LojaLoading extends LojaState {}

class LojaSuccess extends LojaState {
  final List<Loja> itens;
  LojaSuccess(this.itens);

  @override
  List<Object?> get props => [itens];
}

class LojaError extends LojaState {
  final String message;
  LojaError(this.message);

  @override
  List<Object?> get props => [message];
}