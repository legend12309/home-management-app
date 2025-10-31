import 'package:equatable/equatable.dart';
import '../../../core/models/meal_model.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

class MealInitial extends MealState {}

class MealLoading extends MealState {}

class MealLoaded extends MealState {
  final MealPlan? currentMealPlan;
  final List<Meal> recipes;

  const MealLoaded({
    this.currentMealPlan,
    required this.recipes,
  });

  @override
  List<Object?> get props => [currentMealPlan, recipes];
}

class MealGenerated extends MealState {
  final MealPlan mealPlan;

  const MealGenerated(this.mealPlan);

  @override
  List<Object?> get props => [mealPlan];
}

class MealError extends MealState {
  final String message;

  const MealError(this.message);

  @override
  List<Object?> get props => [message];
}

