import 'package:equatable/equatable.dart';

abstract class BotEvent extends Equatable {
  const BotEvent();

  @override
  List<Object?> get props => [];
}

class BotOnStart extends BotEvent {}

class BotOnUpdate extends BotEvent {}
