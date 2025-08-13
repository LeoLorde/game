import 'package:equatable/equatable.dart';

abstract class LojaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LojaStarted extends LojaEvent {}

class LojaUpdated extends LojaEvent {}