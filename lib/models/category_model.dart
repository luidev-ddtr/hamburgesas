import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  @JsonKey(name: 'id_category')
  final int? idCategory; // Nullable para cuando es una nueva entidad antes de ser guardada

  @JsonKey(name: 'category_name')
  final String categoryName;

  Category({this.idCategory, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}