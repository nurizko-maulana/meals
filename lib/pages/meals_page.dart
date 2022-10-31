import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meals/pages/meal_detail_page.dart';

import '../cubit/detail_bloc.dart';
import '../cubit/favorite_bloc.dart';
import '../cubit/meal_bloc.dart';
import '../model/meal.dart';
import '../services/favorite_local_provider.dart';

class MealsPage extends StatefulWidget {
  const MealsPage({super.key});

  @override
  State<MealsPage> createState() => _MealsPageState();
}

class _MealsPageState extends State<MealsPage> {
  String selectedValue = "Beef";
  late Future<List<Meal>> favorite;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text(
            "Beef",
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          value: "Beef"),
      DropdownMenuItem(
          child: Text(
            "Chicken",
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          value: "Chicken"),
      DropdownMenuItem(
          child: Text(
            "Dessert",
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          value: "Dessert"),
      DropdownMenuItem(
          child: Text(
            "Lamb",
            style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          value: "Lamb"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: BlocBuilder<MealBloc, MealState>(
            builder: (context, state) {
              switch (state.status) {
                case MealStatus.failure:
                  return const Center(child: Text('failed to fetch posts'));
                case MealStatus.success:
                  if (state.meals.isEmpty) {
                    return const Center(child: Text('no posts'));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What \ndo you like to eat',
                        style: GoogleFonts.lato(
                            fontSize: 40, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors
                                    .white, //background color of dropdown button
                                border: Border.all(
                                    color: Colors.black38,
                                    width: 3), //border of dropdown button
                                borderRadius: BorderRadius.circular(
                                    50), //border raiuds of dropdown button
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                margin: const EdgeInsets.only(left: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: selectedValue,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedValue = newValue!;
                                          context.read<MealBloc>().add(
                                              MealFetchedCategory(
                                                  mealCategory: newValue));
                                        });
                                      },
                                      items: dropdownItems),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              favorite =
                                  FavoriteLocalProvider.db.getFavoriteMeals();

                              Get.bottomSheet(
                                Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Favorite Meals',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: FutureBuilder(
                                          initialData: <Meal>[],
                                          future: favorite,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Meal>>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  snapshot.error.toString());
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.done) {
                                              List<Meal>? favoriteFoods =
                                                  snapshot.data;
                                              if (favoriteFoods!.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                    "No Favorite Available",
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          58, 66, 86, 1.0),
                                                      fontSize: 20.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              } else {
                                                return SizedBox(
                                                  height: 300,
                                                  child: ListView(
                                                      children: favoriteFoods
                                                          .map((item) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50.0),
                                                                  child: Image
                                                                      .network(
                                                                    item.strMealThumb,
                                                                    height:
                                                                        80.0,
                                                                    width: 80.0,
                                                                  )),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                        item
                                                                            .strMeal,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: GoogleFonts.lato(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 16)),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              FavoriteLocalProvider
                                                                  .db
                                                                  .deleteFavoriteMealsById(
                                                                      item
                                                                          .idMeal)
                                                                  .then(
                                                                      (value) {
                                                                if (value > 0) {
                                                                  setState(
                                                                      () {
                                                                        
                                                                      });
                                                                }
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.grey,
                                                              size: 30.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList()),
                                                );
                                              }
                                            } else {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                            icon: BlocBuilder<FavoriteCubit, int>(
                                builder: (context, state) {
                              return Badge(
                                badgeContent: Text(state.toString(),
                                    style: GoogleFonts.lato(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800)),
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        // height: 400,
                        child: ListView.builder(
                            itemCount: state.meals.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  await context
                                      .read<DetailCubit>()
                                      .fetchMealDetail(
                                          state.meals[index].idMeal);
                                  Get.to(const MealDetailPage());
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              child: Image.network(
                                                state.meals[index].strMealThumb,
                                                height: 80.0,
                                                width: 80.0,
                                              )),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                    state.meals[index].strMeal,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 16)),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () => context
                                            .read<FavoriteCubit>()
                                            .increment(),
                                        icon: const Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.grey,
                                          size: 30.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  );

                case MealStatus.initial:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
