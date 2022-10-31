import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meals/model/meal.dart';
// import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc({required this.httpClient, required this.mealCategory})
      : super(const MealState()) {
    on<MealFetched>((event, emit) async{
      await _onMealFetched(event, emit);
    });
    on<MealFetchedCategory>((event, emit) async{
      await _onMealFetchedCategory(event, emit);
    });
  }

  final http.Client httpClient;
  final String mealCategory;

  Future<void> _onMealFetchedCategory(
    MealFetchedCategory event,
    Emitter<MealState> emit,
  ) async {
    try {
      if (state.status == MealStatus.initial) {
        final meals = await _fetchMeals(event.mealCategory);
        return emit(
          state.copyWith(
            status: MealStatus.success,
            meals: meals,
            hasReachedMax: false,
          ),
        );
      }
      final meals = await _fetchMeals(event.mealCategory);
      meals.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: MealStatus.success,
                meals: List.of(state.meals)..addAll(meals),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: MealStatus.failure));
    }
  }

  Future<void> _onMealFetched(
    MealFetched event,
    Emitter<MealState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MealStatus.initial) {
        final meals = await _fetchMeals(event.mealCategory);
        return emit(
          state.copyWith(
            status: MealStatus.success,
            meals: meals,
            hasReachedMax: false,
          ),
        );
      }
      final meals = await _fetchMeals(event.mealCategory);
      meals.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: MealStatus.success,
                meals: List.of(state.meals)..addAll(meals),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: MealStatus.failure));
    }
  }

  Future<List<Meal>> _fetchMeals(String mealCategory) async {
    final response = await httpClient.get(
      Uri.https(
        'themealdb.com',
        '/api/json/v1/1/filter.php',
        <String, String>{'c': mealCategory},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['meals'] as Iterable).map((e) => Meal.fromJson(e)).toList();
    }
    throw Exception('error fetching meals');
  }
}
