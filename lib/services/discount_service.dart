class DiscountService {
  final double total;
  DiscountService(this.total);
  double get discountAmount => total > 10 ? total * 0.1 : 0;
}
