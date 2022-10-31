import 'package:flutter/material.dart';
// import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:meals/cubit/meal_bloc.dart';
import 'cubit/detail_bloc.dart';
import 'cubit/favorite_bloc.dart';
import 'cubit/favorite_observer.dart';
import 'pages/meals_page.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = FavoriteObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DetailCubit(),
        ),
        BlocProvider(
          create: (_) => FavoriteCubit(),
        ),
        BlocProvider<MealBloc>(
          create: (BuildContext context) =>
              MealBloc(httpClient: http.Client(), mealCategory: "Beef")..add(MealFetched(mealCategory: "Beef")),
        ),
      ],
      child: const GetMaterialApp(
          debugShowCheckedModeBanner: false, home:  MealsPage()),
    );
  }
}
