import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  const Meal({
    required this.strMeal,
    required this.strMealThumb,
    required this.idMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
  });

  final String strMeal;
  final String strMealThumb;
  final String idMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;

  @override
  List<Object> get props =>
      [strMeal, strMealThumb, idMeal, strCategory, strArea, strInstructions];

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        strMeal: json["strMeal"],
        strMealThumb: json["strMealThumb"],
        idMeal: json["idMeal"],
        strCategory: json["strCategory"] ?? "",
        strArea: json["strArea"] ?? "",
        strInstructions: json["strInstructions"] ?? "",
      );
  Map<String, dynamic> toJson() => {
        "strMeal": strMeal,
        "strMealThumb": strMealThumb,
        "idMeal": idMeal,
        "strCategory": strCategory,
        "strArea": strArea,
        "strInstructions": strInstructions,
      };
}
