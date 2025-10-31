import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/grocery_model.dart';

class GroceryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pantry Items (Groceries in home)
  Stream<List<GroceryItem>> getGroceryItems(String familyId) {
    return _firestore
        .collection('groceryItems')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroceryItem.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addGroceryItem(GroceryItem item) async {
    try {
      await _firestore
          .collection('groceryItems')
          .add(item.toFirestore());
    } catch (e) {
      throw Exception('Failed to add grocery item: $e');
    }
  }

  Future<void> updateGroceryItem(GroceryItem item) async {
    try {
      await _firestore
          .collection('groceryItems')
          .doc(item.id)
          .update(item.toFirestore());
    } catch (e) {
      throw Exception('Failed to update grocery item: $e');
    }
  }

  Future<void> deleteGroceryItem(String itemId) async {
    try {
      await _firestore.collection('groceryItems').doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete grocery item: $e');
    }
  }

  // Shopping Lists
  Stream<List<GroceryList>> getShoppingLists(String familyId) {
    return _firestore
        .collection('shoppingLists')
        .where('familyId', isEqualTo: familyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GroceryList.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addShoppingList(GroceryList list) async {
    try {
      await _firestore.collection('shoppingLists').add(list.toFirestore());
    } catch (e) {
      throw Exception('Failed to add shopping list: $e');
    }
  }

  Future<void> deleteShoppingList(String listId) async {
    try {
      await _firestore.collection('shoppingLists').doc(listId).delete();
    } catch (e) {
      throw Exception('Failed to delete shopping list: $e');
    }
  }

  // Statistics
  Future<Map<String, int>> getGroceryStats(String familyId) async {
    try {
      final snapshot = await _firestore
          .collection('groceryItems')
          .where('familyId', isEqualTo: familyId)
          .get();

      int inStock = 0;
      int lowStock = 0;
      int outOfStock = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String;
        if (status == 'in_stock') {
          inStock++;
        } else if (status == 'low') {
          lowStock++;
        } else if (status == 'out_of_stock') {
          outOfStock++;
        }
      }

      return {
        'in_stock': inStock,
        'low': lowStock,
        'out_of_stock': outOfStock,
      };
    } catch (e) {
      throw Exception('Failed to get grocery stats: $e');
    }
  }
}

