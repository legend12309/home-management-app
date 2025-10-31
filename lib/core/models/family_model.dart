import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyModel {
  final String id;
  final String familyName;
  final String adminId;
  final List<String> members;
  final String inviteCode;
  final DateTime createdAt;

  FamilyModel({
    required this.id,
    required this.familyName,
    required this.adminId,
    required this.members,
    required this.inviteCode,
    required this.createdAt,
  });

  factory FamilyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyModel(
      id: doc.id,
      familyName: data['familyName'] as String,
      adminId: data['adminId'] as String,
      members: List<String>.from(data['members'] ?? []),
      inviteCode: data['inviteCode'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'familyName': familyName,
      'adminId': adminId,
      'members': members,
      'inviteCode': inviteCode,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FamilyModel copyWith({
    String? id,
    String? familyName,
    String? adminId,
    List<String>? members,
    String? inviteCode,
    DateTime? createdAt,
  }) {
    return FamilyModel(
      id: id ?? this.id,
      familyName: familyName ?? this.familyName,
      adminId: adminId ?? this.adminId,
      members: members ?? this.members,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

