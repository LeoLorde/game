import 'package:equatable/equatable.dart';
import 'package:game/core/models/creature_model.dart';

abstract class ColecaoState extends Equatable {
  const ColecaoState();

  @override
  List<Object?> get props => [];
}

class ColecaoOnLoading extends ColecaoState {}

class ColecaoOnError extends ColecaoState {
  final String message;
  const ColecaoOnError(this.message);

  @override
  List<Object?> get props => [message];
}

class ColecaoOnSuccess extends ColecaoState {
  final List<Creature> criaturas;
  const ColecaoOnSuccess(this.criaturas);

  @override
  List<Object?> get props => [criaturas];
}
