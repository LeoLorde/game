import 'package:equatable/equatable.dart';

abstract class BattleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BattleStarted extends BattleEvent {}

class BattleUpdated extends BattleEvent {}