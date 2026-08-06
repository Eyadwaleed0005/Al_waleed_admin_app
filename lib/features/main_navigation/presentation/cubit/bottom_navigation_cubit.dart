import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationCubit extends Cubit<int> {
  BottomNavigationCubit() : super(0);

  void changePage(int newIndex) {
    if (newIndex == state) return;

    emit(newIndex);
  }
}