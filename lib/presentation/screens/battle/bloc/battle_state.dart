import 'package:equatable/equatable.dart';
import 'package:game/core/classes/battle.dart';
import 'package:game/core/models/creature_model.dart';

abstract class BattleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BattleLoading extends BattleState {}

class BattleSuccess extends BattleState {
  final List<Creature> player_creatures;
  final List<Creature> bot_creatures;

  BattleSuccess(this.player_creatures, this.bot_creatures);

  @override
  List<Object?> get props => [player_creatures, bot_creatures];
}

class BattleError extends BattleState {
  final String message;
  BattleError(this.message);

  @override
  List<Object?> get props => [message];
}

class BattleStartState extends BattleState {
  final List<Creature> player_creatures;
  final List<Creature> bot_creatures;

  BattleStartState(this.player_creatures, this.bot_creatures);

  @override
  List<Object?> get props => [player_creatures, bot_creatures];
}

class BattleEndend extends BattleState 
{
  final bool player_won;
  BattleEndend(this.player_won);

  @override
  List<Object?> get props => [player_won];
}