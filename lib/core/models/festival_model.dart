class Festival {
  final String? id;
  final String name;
  final DateTime date;
  final String type; // major, minor
  final String description;
  final String region;
  final String? familyId;

  Festival({
    this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.description,
    required this.region,
    this.familyId,
  });

  factory Festival.fromJson(Map<String, dynamic> json, String docId) {
    return Festival(
      id: docId,
      name: json['name'] as String,
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : (json['date'] as dynamic).toDate(),
      type: json['type'] as String,
      description: json['description'] as String,
      region: json['region'] as String,
      familyId: json['familyId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
      'type': type,
      'description': description,
      'region': region,
      'familyId': familyId,
    };
  }

  Festival copyWith({
    String? id,
    String? name,
    DateTime? date,
    String? type,
    String? description,
    String? region,
    String? familyId,
  }) {
    return Festival(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      type: type ?? this.type,
      description: description ?? this.description,
      region: region ?? this.region,
      familyId: familyId ?? this.familyId,
    );
  }
}

