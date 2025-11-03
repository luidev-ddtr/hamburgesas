class OrderDetail {
  final String productName;
  final int quantity;

  OrderDetail({
    required this.productName,
    required this.quantity,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productName: json['product_name'],
      quantity: json['quantity'],
    );
  }
}