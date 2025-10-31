import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

class MealPlannerScreen extends StatelessWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.mealPlanner),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () {
              // TODO: Navigate to recipe book
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Generate Meal Plan Button
          Card(
            color: AppColors.primary,
            child: InkWell(
              onTap: () {
                // TODO: Implement AI meal plan generation
                _showMealPlanDialog(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Text(
                      'Generate AI Meal Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Weekly Meal Plan
          ...List.generate(7, (index) => _buildDayMealCard(context, index)),
        ],
      ),
    );
  }

  void _showMealPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Meal Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select your preferences:'),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(AppStrings.vegetarian),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text(AppStrings.nonVegetarian),
              value: false,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Generate meal plan
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  Widget _buildDayMealCard(BuildContext context, int index) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          days[index],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          _buildMealType(context, 'Breakfast', Icons.wb_sunny),
          _buildMealType(context, 'Lunch', Icons.lunch_dining),
          _buildMealType(context, 'Dinner', Icons.dinner_dining),
        ],
      ),
    );
  }

  Widget _buildMealType(BuildContext context, String mealType, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(mealType),
      subtitle: const Text('Sample dish'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Navigate to recipe details
      },
    );
  }
}

