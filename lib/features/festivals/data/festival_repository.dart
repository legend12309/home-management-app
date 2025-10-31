import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/festival_model.dart';
import '../../../core/api/hindu_calendar_api.dart';

class FestivalRepository {
  final FirebaseFirestore _firestore;
  final HinduCalendarApi _calendarApi;

  FestivalRepository(this._firestore, this._calendarApi);

  // Get festivals from API for a specific month/year
  Future<List<Festival>> getFestivalsFromAPI(int month, int year) async {
    try {
      final festivals = await _calendarApi.getFestivals(month, year);
      return festivals
          .map((f) => Festival.fromJson(f, ''))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch festivals: $e');
    }
  }

  // Get upcoming festivals
  Future<List<Festival>> getUpcomingFestivals() async {
    try {
      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      // Get current and next month festivals
      final currentMonth = await getFestivalsFromAPI(month, year);
      
      if (month == 12) {
        final nextMonth = await getFestivalsFromAPI(1, year + 1);
        return [...currentMonth, ...nextMonth]
          ..where((f) => f.date.isAfter(now))
          ..toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      } else {
        final nextMonth = await getFestivalsFromAPI(month + 1, year);
        return [...currentMonth, ...nextMonth]
          ..where((f) => f.date.isAfter(now))
          ..toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      }
    } catch (e) {
      throw Exception('Failed to get upcoming festivals: $e');
    }
  }

  // Get festivals for family
  Stream<List<Festival>> getFamilyFestivals(String familyId) {
    return _firestore
        .collection('festivals')
        .where('familyId', isEqualTo: familyId)
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Festival.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Add custom festival for family
  Future<void> addFamilyFestival(Festival festival) async {
    try {
      await _firestore.collection('festivals').add(festival.toJson());
    } catch (e) {
      throw Exception('Failed to add festival: $e');
    }
  }

  Future<void> deleteFamilyFestival(String festivalId) async {
    try {
      await _firestore.collection('festivals').doc(festivalId).delete();
    } catch (e) {
      throw Exception('Failed to delete festival: $e');
    }
  }
}

