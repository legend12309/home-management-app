import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/festival_repository.dart';
import '../../../core/models/festival_model.dart';
import 'festival_state.dart';

class FestivalCubit extends Cubit<FestivalState> {
  final FestivalRepository festivalRepository;
  String? currentFamilyId;

  FestivalCubit(this.festivalRepository) : super(FestivalInitial());

  void loadFestivals({String? familyId}) {
    currentFamilyId = familyId;
    emit(FestivalLoading());

    // Load upcoming festivals from API
    festivalRepository.getUpcomingFestivals().then((upcomingFestivals) {
      // Load family custom festivals if family ID provided
      if (familyId != null && familyId.isNotEmpty) {
        festivalRepository.getFamilyFestivals(familyId).listen(
          (familyFestivals) {
            emit(FestivalLoaded(
              upcomingFestivals: upcomingFestivals,
              familyFestivals: familyFestivals,
            ));
          },
          onError: (error) => emit(FestivalError(error.toString())),
        );
      } else {
        emit(FestivalLoaded(
          upcomingFestivals: upcomingFestivals,
          familyFestivals: [],
        ));
      }
    }).catchError((error) {
      emit(FestivalError(error.toString()));
    });
  }

  Future<void> addFamilyFestival({
    required String name,
    required DateTime date,
    required String description,
    required String region,
    required String familyId,
    String type = 'minor',
  }) async {
    try {
      final festival = Festival(
        name: name,
        date: date,
        type: type,
        description: description,
        region: region,
        familyId: familyId,
      );

      await festivalRepository.addFamilyFestival(festival);
      // Real-time updates will automatically refresh through stream
    } catch (e) {
      emit(FestivalError(e.toString()));
    }
  }

  Future<void> deleteFamilyFestival(String festivalId) async {
    try {
      await festivalRepository.deleteFamilyFestival(festivalId);
    } catch (e) {
      emit(FestivalError(e.toString()));
    }
  }
}

