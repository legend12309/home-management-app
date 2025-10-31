import 'api_client.dart';

class MealPlanApi {
  final ApiClient _apiClient;

  MealPlanApi(this._apiClient);

  Future<Map<String, dynamic>> generateMealPlan({
    required String dietType,
    String? festival,
    List<String>? preferences,
    int familySize = 4,
  }) async {
    try {
      final response = await _apiClient.post('/mealplan/generate', data: {
        'dietType': dietType,
        'festival': festival,
        'preferences': preferences,
        'familySize': familySize,
      });
      return response.data['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to generate meal plan: $e');
    }
  }
}

