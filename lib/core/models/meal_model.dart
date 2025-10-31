class Meal {
  final String? id;
  final String name;
  final String region;
  final bool isVegetarian;
  final int prepTime; // in minutes
  final List<String> ingredients;
  final String? instructions;
  final String uploadedBy;
  final DateTime createdAt;
  final String? familyId;

  Meal({
    this.id,
    required this.name,
    required this.region,
    required this.isVegetarian,
    required this.prepTime,
    required this.ingredients,
    this.instructions,
    required this.uploadedBy,
    required this.createdAt,
    this.familyId,
  });

  factory Meal.fromJson(Map<String, dynamic> json, String docId) {
    return Meal(
      id: docId,
      name: json['name'] as String,
      region: json['region'] as String,
      isVegetarian: json['isVegetarian'] as bool? ?? true,
      prepTime: json['prepTime'] as int? ?? 30,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] as String?,
      uploadedBy: json['uploadedBy'] as String,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      familyId: json['familyId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'isVegetarian': isVegetarian,
      'prepTime': prepTime,
      'ingredients': ingredients,
      'instructions': instructions,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt,
      'familyId': familyId,
    };
  }
}

class MealPlan {
  final String? id;
  final String week; // e.g., "November 1-7, 2025"
  final String dietType;
  final String? festival;
  final List<DayMeal> meals;
  final String familyId;
  final DateTime createdAt;

  MealPlan({
    this.id,
    required this.week,
    required this.dietType,
    this.festival,
    required this.meals,
    required this.familyId,
    required this.createdAt,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json, String docId) {
    return MealPlan(
      id: docId,
      week: json['week'] as String,
      dietType: json['dietType'] as String,
      festival: json['festival'] as String?,
      meals: (json['meals'] as List? ?? [])
          .map((m) => DayMeal.fromJson(m))
          .toList(),
      familyId: json['familyId'] as String,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': week,
      'dietType': dietType,
      'festival': festival,
      'meals': meals.map((m) => m.toJson()).toList(),
      'familyId': familyId,
      'createdAt': createdAt,
    };
  }
}

class DayMeal {
  final String day;
  final Meal breakfast;
  final Meal lunch;
  final Meal dinner;

  DayMeal({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory DayMeal.fromJson(Map<String, dynamic> json) {
    return DayMeal(
      day: json['day'] as String,
      breakfast: Meal.fromJson(json['breakfast'] as Map<String, dynamic>, ''),
      lunch: Meal.fromJson(json['lunch'] as Map<String, dynamic>, ''),
      dinner: Meal.fromJson(json['dinner'] as Map<String, dynamic>, ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'breakfast': breakfast.toJson(),
      'lunch': lunch.toJson(),
      'dinner': dinner.toJson(),
    };
  }
}

