import 'package:equatable/equatable.dart';

abstract class BattleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BattleStarted extends BattleEvent {}

class BattleUpdated extends BattleEvent {}

class PlayerActionEvent extends BattleEvent {
  final dynamic action;

  PlayerActionEvent(this.action);

  @override
  List<Object?> get props => [action];
}

class BattleEndend extends BattleEvent {}