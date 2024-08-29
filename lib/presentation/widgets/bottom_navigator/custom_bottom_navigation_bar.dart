import 'package:flutter/material.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/custom_bottom_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<CustomBottomNavigationBarItem> items;
  final void Function(int index) onTap;
  final int selectedIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? backgroundColor;

  const CustomBottomNavigationBar(
      {super.key,
      required this.items,
      required this.onTap,
      required this.selectedIndex,
      this.backgroundColor = Colors.white,
      this.selectedItemColor = Colors.black,
      this.unselectedItemColor = Colors.grey})
      : assert(items.length >= 2);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    const double bottomNavigationBarHeight =
        kBottomNavigationBarHeight + (kBottomNavigationBarHeight * 0.2);
    return Container(
      height: bottomNavigationBarHeight,
      decoration: BoxDecoration(color: widget.backgroundColor),
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          const Spacer(),
          ...widget.items.asMap().entries.map((currentItem) => Expanded(
                  child: InternalItem(
                icon: currentItem.value.icon,
                label: currentItem.value.label,
                onTap: widget.onTap,
                index: currentItem.key,
                color: widget.selectedIndex == currentItem.key
                    ? widget.selectedItemColor!
                    : widget.unselectedItemColor!,
              ))),
          const Spacer()
        ],
      ),
    );
  }
}

class InternalItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final Color color;
  final void Function(int index) onTap;
  const InternalItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap,
      required this.index,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 11),
          )
        ],
      ),
    );
  }
}
