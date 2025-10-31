import 'package:equatable/equatable.dart';
import '../../../core/models/chore_model.dart';

abstract class ChoreState extends Equatable {
  const ChoreState();

  @override
  List<Object?> get props => [];
}

class ChoreInitial extends ChoreState {}

class ChoreLoading extends ChoreState {}

class ChoreLoaded extends ChoreState {
  final List<Chore> chores;
  final Map<String, int> stats;

  const ChoreLoaded({
    required this.chores,
    required this.stats,
  });

  @override
  List<Object?> get props => [chores, stats];
}

class ChoreError extends ChoreState {
  final String message;

  const ChoreError(this.message);

  @override
  List<Object?> get props => [message];
}

