class Budget {
  final String? id;
  final double monthlyBudget;
  final String familyId;
  final int month; // 1-12
  final int year;
  final DateTime createdAt;

  Budget({
    this.id,
    required this.monthlyBudget,
    required this.familyId,
    required this.month,
    required this.year,
    required this.createdAt,
  });

  factory Budget.fromFirestore(Map<String, dynamic> json, String docId) {
    return Budget(
      id: docId,
      monthlyBudget: (json['monthlyBudget'] as num).toDouble(),
      familyId: json['familyId'] as String,
      month: json['month'] as int,
      year: json['year'] as int,
      createdAt: (json['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'monthlyBudget': monthlyBudget,
      'familyId': familyId,
      'month': month,
      'year': year,
      'createdAt': createdAt,
    };
  }

  Budget copyWith({
    String? id,
    double? monthlyBudget,
    String? familyId,
    int? month,
    int? year,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      familyId: familyId ?? this.familyId,
      month: month ?? this.month,
      year: year ?? this.year,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Expense {
  final String? id;
  final double amount;
  final String category;
  final String description;
  final String familyId;
  final String addedBy;
  final DateTime createdAt;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.familyId,
    required this.addedBy,
    required this.createdAt,
  });

  factory Expense.fromFirestore(Map<String, dynamic> json, String docId) {
    return Expense(
      id: docId,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String,
      familyId: json['familyId'] as String,
      addedBy: json['addedBy'] as String,
      createdAt: (json['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'category': category,
      'description': description,
      'familyId': familyId,
      'addedBy': addedBy,
      'createdAt': createdAt,
    };
  }

  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    String? description,
    String? familyId,
    String? addedBy,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      familyId: familyId ?? this.familyId,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

