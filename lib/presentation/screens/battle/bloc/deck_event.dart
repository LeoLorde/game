import 'package:equatable/equatable.dart';

abstract class DeckEvent extends Equatable {
  const DeckEvent();

  @override
  List<Object?> get props => [];
}

class DeckOnStart extends DeckEvent {}

class DeckOnUpdate extends DeckEvent {}
