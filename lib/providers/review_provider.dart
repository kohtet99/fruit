// review_provider.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/models/review.dart';

class ReviewProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Review>> getReviewsForProduct(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('date', descending: true)
        .snapshots()
        .handleError((error) {
        log("Firestore error: $error");
        return Stream.value([]); 
      })
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> addReview(Review review) async {
    try {
      await _firestore
          .collection('reviews')
          .doc(review.id)
          .set(review.toMap());
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}