import 'package:equatable/equatable.dart';

abstract class ColecaoEvent extends Equatable {
  const ColecaoEvent();

  @override
  List<Object?> get props => [];
}

class ColecaoOnStart extends ColecaoEvent {}

class ColecaoOnUpdate extends ColecaoEvent {}
