import 'package:bloc/bloc.dart';

class FavoriteCubit extends Cubit<int> {
  FavoriteCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
