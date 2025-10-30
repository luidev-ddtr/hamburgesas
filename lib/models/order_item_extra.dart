import 'package:json_annotation/json_annotation.dart';

part 'order_item_extra.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItemExtra {
  @JsonKey(name: 'id_order_item_extra')
  final int? idOrderItemExtra;

  @JsonKey(name: 'id_order_item')
  final int idOrderItem; // FOREIGN KEY, NOT NULL

  @JsonKey(name: 'id_extra')
  final int idExtra; // FOREIGN KEY, NOT NULL

  final int quantity;

  @JsonKey(name: 'unit_price_at_order')
  final double unitPriceAtOrder;

  OrderItemExtra(
      {this.idOrderItemExtra,
      required this.idOrderItem,
      required this.idExtra,
      this.quantity = 1, // Default value
      required this.unitPriceAtOrder});

  factory OrderItemExtra.fromJson(Map<String, dynamic> json) => _$OrderItemExtraFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemExtraToJson(this);
}