part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class MealFetched extends MealEvent {
  final String mealCategory;

  MealFetched({required this.mealCategory});
}
class MealFetchedCategory extends MealEvent {
  final String mealCategory;

  MealFetchedCategory({required this.mealCategory});
}
