import 'package:equatable/equatable.dart';

class NavigatorCubitState extends Equatable {
  final bool isExpandibleControllerSmall;
  final int bottomNavigatorIndex;
  final int bottomNavigatorLastndex;
  final int topNavigatorIndex;
  final int topNavigatorLastIndex;

  const NavigatorCubitState(
      {this.isExpandibleControllerSmall = true,
      this.bottomNavigatorIndex = 0,
      this.bottomNavigatorLastndex = 0,
      this.topNavigatorIndex = 0,
      this.topNavigatorLastIndex = 0});

  NavigatorCubitState copyWith(
      {bool? isExpandibleControllerSmall,
      int? bottomNavigatorIndex,
      int? bottomNavigatorLastndex,
      int? topNavigatorIndex,
      int? topNavigatorLastIndex}) {
    return NavigatorCubitState(
        isExpandibleControllerSmall:
            isExpandibleControllerSmall ?? this.isExpandibleControllerSmall,
        bottomNavigatorIndex: bottomNavigatorIndex ?? this.bottomNavigatorIndex,
        bottomNavigatorLastndex:
            bottomNavigatorLastndex ?? this.bottomNavigatorLastndex,
        topNavigatorIndex: topNavigatorIndex ?? this.topNavigatorIndex,
        topNavigatorLastIndex:
            topNavigatorLastIndex ?? this.topNavigatorLastIndex);
  }

  @override
  List<Object?> get props => [
        isExpandibleControllerSmall,
        bottomNavigatorIndex,
        bottomNavigatorLastndex,
        topNavigatorIndex,
        topNavigatorLastIndex
      ];
}
