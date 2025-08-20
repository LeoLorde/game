import 'package:equatable/equatable.dart';
import 'package:game/core/models/creature_model.dart';

abstract class BotState extends Equatable {
  const BotState();

  @override
  List<Object?> get props => [];
}

class BotOnLoading extends BotState {}

class BotOnError extends BotState {
  final String message;
  const BotOnError(this.message);

  @override
  List<Object?> get props => [message];
}

class BotOnSuccess extends BotState {
  final List<Creature> criaturas;
  const BotOnSuccess(this.criaturas);

  @override
  List<Object?> get props => [criaturas];
}
