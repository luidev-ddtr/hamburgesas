import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Order {
  @JsonKey(name: 'id_order')
  final int? idOrder;

  final double total;

  @JsonKey(name: 'order_date')
  final DateTime orderDate;

  Order({this.idOrder, this.total = 0.0, required this.orderDate});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
  Map<String, dynamic> toJson() => _$OrderToJson(this);
} 