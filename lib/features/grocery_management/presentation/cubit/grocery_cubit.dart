import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/grocery_repository.dart';
import '../../../core/models/grocery_model.dart';
import 'grocery_state.dart';

class GroceryCubit extends Cubit<GroceryState> {
  final GroceryRepository groceryRepository;
  String? currentFamilyId;

  GroceryCubit(this.groceryRepository) : super(GroceryInitial());

  void loadGroceries(String familyId) {
    currentFamilyId = familyId;
    emit(GroceryLoading());

    groceryRepository.getGroceryItems(familyId).listen(
      (items) {
        groceryRepository.getShoppingLists(familyId).listen(
          (shoppingLists) {
            groceryRepository.getGroceryStats(familyId).then((stats) {
              emit(GroceryLoaded(
                items: items,
                stats: stats,
                shoppingLists: shoppingLists,
              ));
            }).catchError((error) {
              emit(GroceryError(error.toString()));
            });
          },
          onError: (error) => emit(GroceryError(error.toString())),
        );
      },
      onError: (error) => emit(GroceryError(error.toString())),
    );
  }

  Future<void> addGroceryItem({
    required String itemName,
    required int quantity,
    required String unit,
    required String status,
    required String addedBy,
    required String familyId,
    DateTime? expiryDate,
    String? notes,
  }) async {
    try {
      final item = GroceryItem(
        itemName: itemName,
        quantity: quantity,
        unit: unit,
        status: status,
        expiryDate: expiryDate,
        notes: notes,
        addedBy: addedBy,
        createdAt: DateTime.now(),
        familyId: familyId,
      );

      await groceryRepository.addGroceryItem(item);
      // Real-time updates will automatically refresh through stream
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }

  Future<void> updateGroceryItem(GroceryItem item) async {
    try {
      await groceryRepository.updateGroceryItem(item);
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }

  Future<void> deleteGroceryItem(String itemId) async {
    try {
      await groceryRepository.deleteGroceryItem(itemId);
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }

  Future<void> addShoppingList({
    required String listName,
    required String createdBy,
    required String familyId,
    List<String> items = const [],
  }) async {
    try {
      final list = GroceryList(
        listName: listName,
        items: items,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        familyId: familyId,
      );

      await groceryRepository.addShoppingList(list);
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }

  Future<void> deleteShoppingList(String listId) async {
    try {
      await groceryRepository.deleteShoppingList(listId);
    } catch (e) {
      emit(GroceryError(e.toString()));
    }
  }
}

