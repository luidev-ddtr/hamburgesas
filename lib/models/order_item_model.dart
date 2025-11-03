import 'package:json_annotation/json_annotation.dart';

part 'order_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  @JsonKey(name: 'id_order_item')
  final int? idOrderItem;

  @JsonKey(name: 'id_order')
  final int idOrder; // FOREIGN KEY, NOT NULL

  @JsonKey(name: 'id_product')
  final int idProduct; // FOREIGN KEY, NOT NULL

  final int quantity;

  @JsonKey(name: 'unit_price_at_order')
  final double unitPriceAtOrder; 
 
  OrderItem( 
      {this.idOrderItem,
      required this.idOrder,
      required this.idProduct,
      this.quantity = 1, // Default value
      required this.unitPriceAtOrder});

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}