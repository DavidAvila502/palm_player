import 'package:palm_player/presentation/cubits/navigator/navigator_cubit.dart';

handleBackButton(NavigatorCubit navigator) {
  final state = navigator.state;

  if (state.isExpandibleControllerSmall != true) {
    return;
  }

  if (state.topNavigatorIndex > 0 &&
      state.bottomNavigatorIndex == 0 &&
      !navigator.topNavigatorPoped) {
    navigator.goBackTopNavigator();
    return;
  }

  navigator.goBackBottomNavigator();

  return;
}
