import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/old/category.dart';

class FirestoreCategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get categories from a specific restaurant in Firestore
  Future<List<Category>> getCategories(String restaurantId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .orderBy('order') // Ensure categories are ordered by 'order' field
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting categories: $e');
      throw e;
    }
  }

  // Function to add a category to a specific restaurant in Firestore
  Future<void> addCategory(Category category, String restaurantId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(category.title) // Using title as document ID
          .set(category.toMap());
    } catch (e) {
      print('Error adding category: $e');
      throw e;
    }
  }

  // Function to update a category in a specific restaurant in Firestore
  Future<void> updateCategory(String restaurantId, Category category) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(category.title)
          .update(category.toMap());
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Function to delete a category from a specific restaurant in Firestore
  Future<void> deleteCategory(String restaurantId, String categoryTitle) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(categoryTitle) // Using title as document ID
          .delete();
    } catch (e) {
      print('Error deleting category: $e');
      throw e;
    }
  }
}
