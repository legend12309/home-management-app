import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/config/router/app_router.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/services/firebase_service.dart';
import 'presentation/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/grocery_management/data/grocery_repository.dart';
import 'features/grocery_management/presentation/cubit/grocery_cubit.dart';
import 'features/meal_planning/data/meal_repository.dart';
import 'features/meal_planning/presentation/cubit/meal_cubit.dart';
import 'core/api/api_client.dart';
import 'core/api/meal_plan_api.dart';
import 'core/api/hindu_calendar_api.dart';
import 'features/chores/data/chore_repository.dart';
import 'features/chores/presentation/cubit/chore_cubit.dart';
import 'features/budget/data/budget_repository.dart';
import 'features/budget/presentation/cubit/budget_cubit.dart';
import 'features/festivals/data/festival_repository.dart';
import 'features/festivals/presentation/cubit/festival_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await setupDependencyInjection();
  runApp(const GharsethuApp());
}

// Dependency Injection Setup
Future<void> setupDependencyInjection() async {
  final getIt = GetIt.instance;

  // API Clients
  final apiClient = ApiClient();
  getIt.registerSingleton<ApiClient>(apiClient);
  getIt.registerSingleton<MealPlanApi>(MealPlanApi(apiClient));
  getIt.registerSingleton<HinduCalendarApi>(HinduCalendarApi(apiClient));

  // Repositories
  getIt.registerSingleton<AuthRepository>(AuthRepository());
  getIt.registerSingleton<GroceryRepository>(GroceryRepository());
  getIt.registerSingleton<MealRepository>(
    MealRepository(getIt<MealPlanApi>()),
  );
  getIt.registerSingleton<ChoreRepository>(ChoreRepository());
  getIt.registerSingleton<BudgetRepository>(BudgetRepository());
  getIt.registerSingleton<FestivalRepository>(
    FestivalRepository(FirebaseFirestore.instance, getIt<HinduCalendarApi>()),
  );

  // Cubits/BLoCs
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<GroceryCubit>(
    () => GroceryCubit(getIt<GroceryRepository>()),
  );
  getIt.registerFactory<MealCubit>(
    () => MealCubit(getIt<MealRepository>()),
  );
  getIt.registerFactory<ChoreCubit>(
    () => ChoreCubit(getIt<ChoreRepository>()),
  );
  getIt.registerFactory<BudgetCubit>(
    () => BudgetCubit(getIt<BudgetRepository>()),
  );
  getIt.registerFactory<FestivalCubit>(
    () => FestivalCubit(getIt<FestivalRepository>()),
  );
}

class GharsethuApp extends StatelessWidget {
  const GharsethuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.instance<AuthCubit>()),
        BlocProvider.value(value: GetIt.instance<GroceryCubit>()),
        BlocProvider.value(value: GetIt.instance<MealCubit>()),
        BlocProvider.value(value: GetIt.instance<ChoreCubit>()),
        BlocProvider.value(value: GetIt.instance<BudgetCubit>()),
        BlocProvider.value(value: GetIt.instance<FestivalCubit>()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

