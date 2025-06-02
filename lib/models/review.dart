import 'package:intl/intl.dart';

class Review {
  final String id;
  final String productId;
  final String userId;
  final String userEmail;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userEmail,
    required this.rating,
    required this.comment,
    required this.date,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy').format(date);

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'userEmail': userEmail,
      'rating': rating,
      'comment': comment,
      'date': date.millisecondsSinceEpoch,
    };
  }
  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      productId: map['productId'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? 'Anonymous',
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] ?? 0),
    );
  }
}