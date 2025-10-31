import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/meal_model.dart';
import '../../../core/api/meal_plan_api.dart';

class MealRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MealPlanApi _mealPlanApi;

  MealRepository(this._mealPlanApi);

  // Get meal plans from Firestore
  Stream<List<MealPlan>> getMealPlans(String familyId) {
    return _firestore
        .collection('mealPlans')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: true)
        .limit(1) // Get latest meal plan
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MealPlan.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Generate AI meal plan via API
  Future<MealPlan> generateMealPlan({
    required String dietType,
    String? festival,
    List<String>? preferences,
    int familySize = 4,
  }) async {
    try {
      final result = await _mealPlanApi.generateMealPlan(
        dietType: dietType,
        festival: festival,
        preferences: preferences,
        familySize: familySize,
      );

      // Convert API response to MealPlan model
      // This will depend on your API response structure
      return MealPlan.fromJson(result, '');
    } catch (e) {
      throw Exception('Failed to generate meal plan: $e');
    }
  }

  // Save meal plan to Firestore
  Future<void> saveMealPlan(MealPlan mealPlan) async {
    try {
      await _firestore
          .collection('mealPlans')
          .add(mealPlan.toJson());
    } catch (e) {
      throw Exception('Failed to save meal plan: $e');
    }
  }

  // Get recipes
  Stream<List<Meal>> getRecipes(String familyId) {
    return _firestore
        .collection('recipes')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Meal.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Add recipe
  Future<void> addRecipe(Meal meal) async {
    try {
      await _firestore.collection('recipes').add(meal.toJson());
    } catch (e) {
      throw Exception('Failed to add recipe: $e');
    }
  }

  // Delete recipe
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception('Failed to delete recipe: $e');
    }
  }
}

