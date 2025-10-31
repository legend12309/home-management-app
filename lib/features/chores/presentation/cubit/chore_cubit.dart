import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/chore_repository.dart';
import '../../../core/models/chore_model.dart';
import 'chore_state.dart';

class ChoreCubit extends Cubit<ChoreState> {
  final ChoreRepository choreRepository;
  String? currentFamilyId;

  ChoreCubit(this.choreRepository) : super(ChoreInitial());

  void loadChores(String familyId) {
    currentFamilyId = familyId;
    emit(ChoreLoading());

    choreRepository.getChores(familyId).listen(
      (chores) {
        choreRepository.getChoreStats(familyId).then((stats) {
          emit(ChoreLoaded(chores: chores, stats: stats));
        }).catchError((error) {
          emit(ChoreError(error.toString()));
        });
      },
      onError: (error) => emit(ChoreError(error.toString())),
    );
  }

  Future<void> addChore({
    required String title,
    required String description,
    required String assignedTo,
    required String assignedBy,
    required String familyId,
    String status = 'pending',
    DateTime? dueDate,
    int priority = 3,
  }) async {
    try {
      final chore = Chore(
        title: title,
        description: description,
        status: status,
        assignedTo: assignedTo,
        assignedBy: assignedBy,
        familyId: familyId,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        priority: priority,
      );

      await choreRepository.addChore(chore);
    } catch (e) {
      emit(ChoreError(e.toString()));
    }
  }

  Future<void> updateChore(Chore chore) async {
    try {
      await choreRepository.updateChore(chore);
    } catch (e) {
      emit(ChoreError(e.toString()));
    }
  }

  Future<void> deleteChore(String choreId) async {
    try {
      await choreRepository.deleteChore(choreId);
    } catch (e) {
      emit(ChoreError(e.toString()));
    }
  }

  Future<void> updateChoreStatus(String choreId, String newStatus) async {
    try {
      if (state is ChoreLoaded) {
        final chores = (state as ChoreLoaded).chores;
        final chore = chores.firstWhere((c) => c.id == choreId);
        await choreRepository.updateChore(chore.copyWith(status: newStatus));
      }
    } catch (e) {
      emit(ChoreError(e.toString()));
    }
  }
}

