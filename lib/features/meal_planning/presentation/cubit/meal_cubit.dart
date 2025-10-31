import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/meal_repository.dart';
import '../../../core/models/meal_model.dart';
import 'meal_state.dart';

class MealCubit extends Cubit<MealState> {
  final MealRepository mealRepository;
  String? currentFamilyId;

  MealCubit(this.mealRepository) : super(MealInitial());

  void loadMeals(String familyId) {
    currentFamilyId = familyId;
    emit(MealLoading());

    mealRepository.getMealPlans(familyId).listen(
      (mealPlans) {
        mealRepository.getRecipes(familyId).listen(
          (recipes) {
            emit(MealLoaded(
              currentMealPlan: mealPlans.isNotEmpty ? mealPlans.first : null,
              recipes: recipes,
            ));
          },
          onError: (error) => emit(MealError(error.toString())),
        );
      },
      onError: (error) => emit(MealError(error.toString())),
    );
  }

  Future<void> generateMealPlan({
    required String dietType,
    String? festival,
    List<String>? preferences,
    int familySize = 4,
  }) async {
    try {
      emit(MealLoading());
      final mealPlan = await mealRepository.generateMealPlan(
        dietType: dietType,
        festival: festival,
        preferences: preferences,
        familySize: familySize,
      );

      if (currentFamilyId != null) {
        await mealRepository.saveMealPlan(mealPlan);
      }

      emit(MealGenerated(mealPlan));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> addRecipe({
    required String name,
    required String region,
    required bool isVegetarian,
    required int prepTime,
    required List<String> ingredients,
    String? instructions,
    required String uploadedBy,
    required String familyId,
  }) async {
    try {
      final meal = Meal(
        name: name,
        region: region,
        isVegetarian: isVegetarian,
        prepTime: prepTime,
        ingredients: ingredients,
        instructions: instructions,
        uploadedBy: uploadedBy,
        createdAt: DateTime.now(),
        familyId: familyId,
      );

      await mealRepository.addRecipe(meal);
      // Real-time updates will automatically refresh through stream
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await mealRepository.deleteRecipe(recipeId);
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }
}

