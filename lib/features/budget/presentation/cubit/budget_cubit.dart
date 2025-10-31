import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/budget_repository.dart';
import '../../../core/models/budget_model.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository budgetRepository;
  String? currentFamilyId;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  BudgetCubit(this.budgetRepository) : super(BudgetInitial());

  void loadBudget(String familyId, {int? month, int? year}) {
    currentFamilyId = familyId;
    currentMonth = month ?? DateTime.now().month;
    currentYear = year ?? DateTime.now().year;

    emit(BudgetLoading());

    budgetRepository.getBudget(familyId, currentMonth, currentYear).then(
      (budget) {
        budgetRepository.getExpenses(familyId, currentMonth, currentYear).listen(
          (expenses) {
            budgetRepository
                .getTotalSpending(familyId, currentMonth, currentYear)
                .then((totalSpending) {
              budgetRepository
                  .getSpendingByCategory(familyId, currentMonth, currentYear)
                  .then((categorySpending) {
                emit(BudgetLoaded(
                  budget: budget,
                  expenses: expenses,
                  totalSpending: totalSpending,
                  categorySpending: categorySpending,
                ));
              }).catchError((error) {
                emit(BudgetError(error.toString()));
              });
            }).catchError((error) {
              emit(BudgetError(error.toString()));
            });
          },
          onError: (error) => emit(BudgetError(error.toString())),
        );
      },
    ).catchError((error) {
      emit(BudgetError(error.toString()));
    });
  }

  Future<void> setBudget(double monthlyBudget, String familyId) async {
    try {
      final budget = Budget(
        monthlyBudget: monthlyBudget,
        familyId: familyId,
        month: currentMonth,
        year: currentYear,
        createdAt: DateTime.now(),
      );

      await budgetRepository.setBudget(budget);
      loadBudget(familyId);
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required String description,
    required String addedBy,
    required String familyId,
  }) async {
    try {
      final expense = Expense(
        amount: amount,
        category: category,
        description: description,
        familyId: familyId,
        addedBy: addedBy,
        createdAt: DateTime.now(),
      );

      await budgetRepository.addExpense(expense);
      loadBudget(familyId);
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await budgetRepository.deleteExpense(expenseId);
      if (currentFamilyId != null) {
        loadBudget(currentFamilyId!);
      }
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}

