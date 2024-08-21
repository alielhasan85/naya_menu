import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/old/meal.dart';

class FirestoreMealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get meals from a specific category in Firestore
  Future<List<Meal>> getMeals(String restaurantId, String categoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(categoryId)
          .collection('meals')
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Meal.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting meals: $e');
      throw e;
    }
  }

  // Function to get and increment the meal counter for a category
  Future<int> getNextMealCounter(String restaurantId, String categoryId) async {
    DocumentReference counterRef = _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('categories')
        .doc(categoryId)
        .collection('counters')
        .doc('mealCounter');
    DocumentSnapshot counterSnapshot = await counterRef.get();

    if (!counterSnapshot.exists) {
      await counterRef.set({'mealCounter': 0});
      return 0;
    } else {
      int currentCounter = counterSnapshot.get('mealCounter');
      await counterRef.update({'mealCounter': FieldValue.increment(1)});
      return currentCounter + 1;
    }
  }

  // Function to add a meal to a category in Firestore
  Future<void> addMeal(
      Meal meal, String restaurantId, String categoryId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(categoryId)
          .collection('meals')
          .doc(meal.id)
          .set(meal.toMap());
    } catch (e) {
      print('Error adding meal: $e');
      throw e;
    }
  }

  // Function to delete a meal from a category in Firestore
  Future<void> deleteMeal(
      String restaurantId, String categoryId, String mealId) async {
    try {
      await _firestore
          .collection('restaurants')
          .doc(restaurantId)
          .collection('categories')
          .doc(categoryId)
          .collection('meals')
          .doc(mealId)
          .delete();
    } catch (e) {
      print('Error deleting meal: $e');
      throw e;
    }
  }
}
