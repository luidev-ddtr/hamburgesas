import 'package:json_annotation/json_annotation.dart';

part 'view_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DashboardOrder {
  @JsonKey(name: 'id_order')
  final int idOrder;

  final double total;

  @JsonKey(name: 'order_date') 
  final DateTime orderDate;

  @JsonKey(name: 'total_products')
  final int totalProducts;

  DashboardOrder({
    required this.idOrder,
    required this.total,
    required this.orderDate,
    required this.totalProducts,
  });

  factory DashboardOrder.fromJson(Map<String, dynamic> json) => 
      _$DashboardOrderFromJson(json);
  
  Map<String, dynamic> toJson() => _$DashboardOrderToJson(this);
}