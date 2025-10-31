class GroceryItem {
  final String? id;
  final String itemName;
  final int quantity;
  final String unit;
  final String status; // in_stock, low, out_of_stock
  final DateTime? expiryDate;
  final String? notes;
  final String addedBy;
  final DateTime createdAt;
  final String familyId;

  GroceryItem({
    this.id,
    required this.itemName,
    required this.quantity,
    this.unit = 'kg',
    required this.status,
    this.expiryDate,
    this.notes,
    required this.addedBy,
    required this.createdAt,
    required this.familyId,
  });

  factory GroceryItem.fromFirestore(Map<String, dynamic> json, String docId) {
    return GroceryItem(
      id: docId,
      itemName: json['itemName'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String? ?? 'kg',
      status: json['status'] as String,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      notes: json['notes'] as String?,
      addedBy: json['addedBy'] as String,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as dynamic).toDate()
          : DateTime.now(),
      familyId: json['familyId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit,
      'status': status,
      'expiryDate': expiryDate?.toIso8601String(),
      'notes': notes,
      'addedBy': addedBy,
      'createdAt': createdAt,
      'familyId': familyId,
    };
  }

  GroceryItem copyWith({
    String? id,
    String? itemName,
    int? quantity,
    String? unit,
    String? status,
    DateTime? expiryDate,
    String? notes,
    String? addedBy,
    DateTime? createdAt,
    String? familyId,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
      familyId: familyId ?? this.familyId,
    );
  }
}

class GroceryList {
  final String? id;
  final String listName;
  final List<String> items;
  final String createdBy;
  final DateTime createdAt;
  final String familyId;

  GroceryList({
    this.id,
    required this.listName,
    required this.items,
    required this.createdBy,
    required this.createdAt,
    required this.familyId,
  });

  factory GroceryList.fromFirestore(Map<String, dynamic> json, String docId) {
    return GroceryList(
      id: docId,
      listName: json['listName'] as String,
      items: List<String>.from(json['items'] ?? []),
      createdBy: json['createdBy'] as String,
      createdAt: (json['createdAt'] as dynamic).toDate(),
      familyId: json['familyId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'listName': listName,
      'items': items,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'familyId': familyId,
    };
  }
}

