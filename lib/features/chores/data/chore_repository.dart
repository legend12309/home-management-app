import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/chore_model.dart';

class ChoreRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Chore>> getChores(String familyId) {
    return _firestore
        .collection('chores')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Chore.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addChore(Chore chore) async {
    try {
      await _firestore.collection('chores').add(chore.toFirestore());
    } catch (e) {
      throw Exception('Failed to add chore: $e');
    }
  }

  Future<void> updateChore(Chore chore) async {
    try {
      await _firestore
          .collection('chores')
          .doc(chore.id)
          .update(chore.toFirestore());
    } catch (e) {
      throw Exception('Failed to update chore: $e');
    }
  }

  Future<void> deleteChore(String choreId) async {
    try {
      await _firestore.collection('chores').doc(choreId).delete();
    } catch (e) {
      throw Exception('Failed to delete chore: $e');
    }
  }

  Future<Map<String, int>> getChoreStats(String familyId) async {
    try {
      final snapshot = await _firestore
          .collection('chores')
          .where('familyId', isEqualTo: familyId)
          .get();

      int pending = 0;
      int inProgress = 0;
      int completed = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String;
        if (status == 'pending') {
          pending++;
        } else if (status == 'in_progress') {
          inProgress++;
        } else if (status == 'completed') {
          completed++;
        }
      }

      return {
        'pending': pending,
        'in_progress': inProgress,
        'completed': completed,
      };
    } catch (e) {
      throw Exception('Failed to get chore stats: $e');
    }
  }
}

