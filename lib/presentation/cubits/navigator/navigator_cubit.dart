import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_player/presentation/cubits/navigator/navigator_cubit_state.dart';

class NavigatorCubit extends Cubit<NavigatorCubitState> {
  NavigatorCubit() : super(const NavigatorCubitState());

  bool topNavigatorPoped = false;
  bool bottomNavigatorPoped = false;

  void updateBottomNavigatorIndex(int newIndex) {
    bottomNavigatorPoped = false;
    int lastIndex = state.bottomNavigatorIndex;

    emit(state.copyWith(
        bottomNavigatorIndex: newIndex, bottomNavigatorLastndex: lastIndex));
  }

  void updateTopNavigatorIndex(int newIndex) {
    topNavigatorPoped = false;
    int lastIndex = state.topNavigatorIndex;

    emit(state.copyWith(
        topNavigatorIndex: newIndex, topNavigatorLastIndex: lastIndex));
  }

  void setIsExpandibleContollerSmall(bool param) {
    emit(state.copyWith(isExpandibleControllerSmall: param));
  }

  void goBackBottomNavigator() {
    if (bottomNavigatorPoped) {
      emit(state.copyWith(bottomNavigatorIndex: 0));
      return;
    }

    bottomNavigatorPoped = true;
    emit(state.copyWith(bottomNavigatorIndex: state.bottomNavigatorLastndex));
  }

  void goBackTopNavigator() {
    topNavigatorPoped = true;

    emit(state.copyWith(topNavigatorIndex: state.topNavigatorLastIndex));
  }
}
