import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/signup_screen.dart';
import '../../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../../features/grocery_management/presentation/screens/grocery_list_screen.dart';
import '../../../features/meal_planning/presentation/screens/meal_planner_screen.dart';
import '../../../features/chores/presentation/screens/chores_screen.dart';
import '../../../features/budget/presentation/screens/budget_screen.dart';
import '../../../features/festivals/presentation/screens/festivals_screen.dart';
import '../../../presentation/screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        name: 'role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/grocery',
        name: 'grocery',
        builder: (context, state) => const GroceryListScreen(),
      ),
      GoRoute(
        path: '/meal-planner',
        name: 'meal-planner',
        builder: (context, state) => const MealPlannerScreen(),
      ),
      GoRoute(
        path: '/chores',
        name: 'chores',
        builder: (context, state) => const ChoresScreen(),
      ),
      GoRoute(
        path: '/budget',
        name: 'budget',
        builder: (context, state) => const BudgetScreen(),
      ),
      GoRoute(
        path: '/festivals',
        name: 'festivals',
        builder: (context, state) => const FestivalsScreen(),
      ),
    ],
  );
}

