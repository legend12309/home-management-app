import 'package:equatable/equatable.dart';
import '../../../core/models/budget_model.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final Budget? budget;
  final List<Expense> expenses;
  final double totalSpending;
  final Map<String, double> categorySpending;

  const BudgetLoaded({
    this.budget,
    required this.expenses,
    required this.totalSpending,
    required this.categorySpending,
  });

  @override
  List<Object?> get props => [budget, expenses, totalSpending, categorySpending];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

