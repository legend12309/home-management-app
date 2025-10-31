import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/budget_model.dart';
import '../cubit/budget_cubit.dart';
import '../cubit/budget_state.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.budget),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_chart),
            onPressed: () => _showSetBudgetDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddExpenseDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BudgetError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshBudget(context),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is BudgetLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Budget Overview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Monthly Budget',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.budget != null
                              ? '₹${state.budget!.monthlyBudget.toStringAsFixed(0)}'
                              : 'Not Set',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (state.budget != null) ...[
                          const SizedBox(height: 24),
                          LinearProgressIndicator(
                            value: state.totalSpending /
                                state.budget!.monthlyBudget,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.primary),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Spent: ₹${state.totalSpending.toStringAsFixed(0)}'),
                              Text(
                                  'Remaining: ₹${(state.budget!.monthlyBudget - state.totalSpending).toStringAsFixed(0)}'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Spending by Category
                if (state.categorySpending.isNotEmpty) ...[
                  Text(
                    'Spending by Category',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...state.categorySpending.entries
                      .map((entry) => _buildCategoryCard(context, entry.key,
                          entry.value, state.budget?.monthlyBudget ?? 0))
                      .toList(),
                ],

                // Recent Expenses
                if (state.expenses.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Recent Expenses',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ...state.expenses.take(10).map(
                        (expense) => _buildExpenseCard(context, expense),
                      ),
                ],
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, String category, double amount, double totalBudget) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.warning,
      AppColors.error,
    ];

    final percentage = totalBudget > 0 ? amount / totalBudget : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors[category.hashCode % colors.length]
              .withOpacity(0.1),
          child: Icon(Icons.category,
              color: colors[category.hashCode % colors.length]),
        ),
        title: Text(category),
        subtitle: Text('${(percentage * 100).toStringAsFixed(1)}% of budget'),
        trailing: Text(
          '₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(BuildContext context, Expense expense) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.receipt_long, color: AppColors.primary),
        ),
        title: Text(expense.description),
        subtitle: Text(expense.category),
        trailing: Text(
          '₹${expense.amount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onLongPress: () => _deleteExpense(context, expense.id!),
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context) {
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Monthly Budget (₹)',
            prefixIcon: Icon(Icons.currency_rupee),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (budgetController.text.isNotEmpty) {
                _setBudget(context, double.parse(budgetController.text));
                Navigator.pop(context);
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    String selectedCategory = 'Groceries';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Expense'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Groceries', child: Text('Groceries')),
                    DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                    DropdownMenuItem(
                        value: 'Entertainment', child: Text('Entertainment')),
                    DropdownMenuItem(value: 'Festivals', child: Text('Festivals')),
                    DropdownMenuItem(value: 'Others', child: Text('Others')),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedCategory = value ?? 'Groceries'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  _addExpense(
                    context,
                    double.parse(amountController.text),
                    selectedCategory,
                    descriptionController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _setBudget(BuildContext context, double amount) {
    // Get from auth context
    context.read<BudgetCubit>().setBudget(amount, 'current_family');
  }

  void _addExpense(
    BuildContext context,
    double amount,
    String category,
    String description,
  ) {
    // Get from auth context
    context.read<BudgetCubit>().addExpense(
          amount: amount,
          category: category,
          description: description,
          addedBy: 'current_user',
          familyId: 'current_family',
        );
  }

  void _deleteExpense(BuildContext context, String expenseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BudgetCubit>().deleteExpense(expenseId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _refreshBudget(BuildContext context) {
    // Refresh budget - will be implemented with auth context
  }
}
