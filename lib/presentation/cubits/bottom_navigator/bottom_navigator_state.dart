import 'package:equatable/equatable.dart';

enum BottomNavigatorStatus { initial, funcitonLoaded, indexSeted }

class BottomNavigatorState extends Equatable {
  final BottomNavigatorStatus navigatoStatus;
  final void Function(int index)? setScreenIndex;
  final int screenIndex;

  const BottomNavigatorState(
      {required this.navigatoStatus,
      this.setScreenIndex,
      this.screenIndex = 0});

  BottomNavigatorState copyWith(
      {BottomNavigatorStatus? navigatoStatus,
      void Function(int index)? setScreenIndex,
      int? screenIndex}) {
    return BottomNavigatorState(
        navigatoStatus: navigatoStatus ?? this.navigatoStatus,
        setScreenIndex: setScreenIndex ?? this.setScreenIndex,
        screenIndex: screenIndex ?? this.screenIndex);
  }

  @override
  List<Object?> get props => [navigatoStatus, setScreenIndex, screenIndex];
}
