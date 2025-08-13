import 'package:equatable/equatable.dart';
import 'package:game/core/models/creature_model.dart';

abstract class DeckState extends Equatable {
  const DeckState();

  @override
  List<Object?> get props => [];
}

class DeckOnLoading extends DeckState {}

class DeckOnError extends DeckState {
  final String message;
  const DeckOnError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeckOnSuccess extends DeckState {
  final List<Creature> criaturas;
  const DeckOnSuccess(this.criaturas);

  @override
  List<Object?> get props => [criaturas];
}
