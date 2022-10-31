import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meals/model/api_return_value.dart';
import 'package:meals/model/meal.dart';
import 'package:equatable/equatable.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailInitial());

  Future<void> fetchMealDetail(String mealId) async {
    ApiReturnValue<Meal> result =  await getMealDetail(mealId);

    if (result.value != null) {
      emit(DetailLoaded(result.value!));
    } else {
      emit(DetailLoadingFailed(result.message!));
    }
  }

  Future<ApiReturnValue<Meal>> getMealDetail(String mealId) async {
  try {
    Response response = await Dio().get('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');
    return ApiReturnValue(value: Meal.fromJson(response.data['meals'][0]));
  } catch (e) {
    ApiReturnValue(message: "fetch data failed");
  }
  return ApiReturnValue(message: "fetch data failed");
}
}
