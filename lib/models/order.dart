import 'package:assignment1/models/product.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<Product> items;
  @HiveField(2)
  final double total;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = 'Completed',
  });

  String get formattedDate => DateFormat('MMM dd, yyyy - hh:mm a').format(date);
}