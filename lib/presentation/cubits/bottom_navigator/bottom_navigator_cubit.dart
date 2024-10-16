import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/bottom_navigator/bottom_navigator_state.dart';

class BottomNavigatorCubit extends Cubit<BottomNavigatorState> {
  BottomNavigatorCubit()
      : super(const BottomNavigatorState(
            navigatoStatus: BottomNavigatorStatus.initial));

  void loadScreenIndex(int index) {
    emit(state.copyWith(
        navigatoStatus: BottomNavigatorStatus.indexSeted, screenIndex: index));
  }

  void loadSetScreenIndex(void Function(int index) func) {
    emit(state.copyWith(
        navigatoStatus: BottomNavigatorStatus.indexSeted,
        setScreenIndex: func));
  }
}
