part of 'meal_bloc.dart';

enum MealStatus { initial, success, failure }

class MealState extends Equatable {
  const MealState({
    this.status = MealStatus.initial,
    this.meals = const <Meal>[],
    this.hasReachedMax = false,
  });

  final MealStatus status;
  final List<Meal> meals;
  final bool hasReachedMax;

  MealState copyWith({
    MealStatus? status,
    List<Meal>? meals,
    bool? hasReachedMax,
  }) {
    return MealState(
      status: status ?? this.status,
      meals: meals ?? this.meals,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }


  @override
  String toString() {
    return '''MealState { status: $status, hasReachedMax: $hasReachedMax, meals: ${meals.length} }''';
  }

  @override
  List<Object> get props => [status, meals, hasReachedMax];
}