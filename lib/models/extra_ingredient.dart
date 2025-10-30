import 'package:json_annotation/json_annotation.dart';

part 'extra_ingredient.g.dart';

@JsonSerializable(explicitToJson: true)
class ExtraIngredient {
  @JsonKey(name: 'id_extra')
  final int? idExtra;

  @JsonKey(name: 'extra_name')
  final String extraName;

  @JsonKey(name: 'extra_price')
  final double extraPrice;

  ExtraIngredient(
      {this.idExtra, required this.extraName, required this.extraPrice});

  factory ExtraIngredient.fromJson(Map<String, dynamic> json) =>
      _$ExtraIngredientFromJson(json);
  Map<String, dynamic> toJson() => _$ExtraIngredientToJson(this);
}