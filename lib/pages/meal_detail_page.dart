import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cubit/detail_bloc.dart';
import '../services/favorite_local_provider.dart';

class MealDetailPage extends StatefulWidget {
  const MealDetailPage({super.key});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          // Row(
          //   children: [

          Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: BlocBuilder<DetailCubit, DetailState>(
          builder: (_, state) {
            if (state is DetailLoaded) {
              return ListView(
                children: [
                  Image.network(state.detail.strMealThumb),
                  Text(
                    state.detail.strMeal,
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Text(
                        "Category :",
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        state.detail.strCategory,
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Area :",
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        state.detail.strArea,
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Instruction :",
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        state.detail.strInstructions,
                        style: GoogleFonts.lato(
                            fontSize: 20, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: ElevatedButton(
                      onPressed: () {
                        FavoriteLocalProvider.db
                            .addFavoriteMeals(state.detail)
                            .then((value) {
                          if (value > 0) {
                            debugPrint("Meals Aded to Favorite");
                            // setState(() => _isFavorite = true);
                            Get.snackbar(
                              "Success",
                              "Meals Aded To Favorite",
                              icon: const Icon(Icons.food_bank,
                                  color: Colors.white),
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              borderRadius: 20,
                              margin: const EdgeInsets.all(15),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 4),
                              isDismissible: true,
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                          }
                        });
                      },
                      child: const Text(
                        "Add To Favorite",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orange[300]!),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            } else {
              return const Center(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
      // ],
      // ),
    );
  }
}
