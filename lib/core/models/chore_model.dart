class Chore {
  final String? id;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed
  final String assignedTo;
  final String assignedBy;
  final String familyId;
  final DateTime createdAt;
  final DateTime? dueDate;
  final int priority; // 1-5, higher = more important

  Chore({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.assignedBy,
    required this.familyId,
    required this.createdAt,
    this.dueDate,
    this.priority = 3,
  });

  factory Chore.fromFirestore(Map<String, dynamic> json, String docId) {
    return Chore(
      id: docId,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      assignedTo: json['assignedTo'] as String,
      assignedBy: json['assignedBy'] as String,
      familyId: json['familyId'] as String,
      createdAt: (json['createdAt'] as dynamic).toDate(),
      dueDate: json['dueDate'] != null
          ? (json['dueDate'] as dynamic).toDate()
          : null,
      priority: json['priority'] as int? ?? 3,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'assignedTo': assignedTo,
      'assignedBy': assignedBy,
      'familyId': familyId,
      'createdAt': createdAt,
      'dueDate': dueDate,
      'priority': priority,
    };
  }

  Chore copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? assignedTo,
    String? assignedBy,
    String? familyId,
    DateTime? createdAt,
    DateTime? dueDate,
    int? priority,
  }) {
    return Chore(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedBy: assignedBy ?? this.assignedBy,
      familyId: familyId ?? this.familyId,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}

