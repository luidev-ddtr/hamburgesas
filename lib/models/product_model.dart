import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Product {
  @JsonKey(name: 'id_product')
  final int? idProduct;

  @JsonKey(name: 'product_name')
  final String productName;

  @JsonKey(name: 'image_path')
  final String? imagePath;

  final double price; // REAL en SQL -> double en Dart

  Product(
      {this.idProduct,
      required this.productName,
      this.imagePath, 
      required this.price
      });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}