import 'package:equatable/equatable.dart';
import '../../../core/models/grocery_model.dart';

abstract class GroceryState extends Equatable {
  const GroceryState();

  @override
  List<Object?> get props => [];
}

class GroceryInitial extends GroceryState {}

class GroceryLoading extends GroceryState {}

class GroceryLoaded extends GroceryState {
  final List<GroceryItem> items;
  final Map<String, int> stats;
  final List<GroceryList> shoppingLists;

  const GroceryLoaded({
    required this.items,
    required this.stats,
    required this.shoppingLists,
  });

  @override
  List<Object?> get props => [items, stats, shoppingLists];
}

class GroceryError extends GroceryState {
  final String message;

  const GroceryError(this.message);

  @override
  List<Object?> get props => [message];
}

