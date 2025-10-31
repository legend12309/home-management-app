import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/budget_model.dart';

class BudgetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get monthly budget
  Future<Budget?> getBudget(String familyId, int month, int year) async {
    try {
      final snapshot = await _firestore
          .collection('budgets')
          .where('familyId', isEqualTo: familyId)
          .where('month', isEqualTo: month)
          .where('year', isEqualTo: year)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return Budget.fromFirestore(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    } catch (e) {
      throw Exception('Failed to get budget: $e');
    }
  }

  Future<void> setBudget(Budget budget) async {
    try {
      await _firestore.collection('budgets').add(budget.toFirestore());
    } catch (e) {
      throw Exception('Failed to set budget: $e');
    }
  }

  // Get expenses for a month
  Stream<List<Expense>> getExpenses(String familyId, int month, int year) {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 1);

    return _firestore
        .collection('expenses')
        .where('familyId', isEqualTo: familyId)
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThan: endDate)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _firestore.collection('expenses').add(expense.toFirestore());
    } catch (e) {
      throw Exception('Failed to add expense: $e');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore.collection('expenses').doc(expenseId).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  // Get spending by category
  Future<Map<String, double>> getSpendingByCategory(
      String familyId, int month, int year) async {
    try {
      final expenses = await getExpenses(familyId, month, year).first;
      final categoryMap = <String, double>{};

      for (var expense in expenses) {
        categoryMap[expense.category] =
            (categoryMap[expense.category] ?? 0) + expense.amount;
      }

      return categoryMap;
    } catch (e) {
      throw Exception('Failed to get spending by category: $e');
    }
  }

  // Get total spending for a month
  Future<double> getTotalSpending(String familyId, int month, int year) async {
    try {
      final expenses = await getExpenses(familyId, month, year).first;
      return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw Exception('Failed to get total spending: $e');
    }
  }
}

