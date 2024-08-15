import 'package:flutter/material.dart';
import 'package:palm_player/presentation/widgets/bottom_navigator/expandible_player_samall_content.dart';

class ExpandiblePlayerController extends StatefulWidget {
  const ExpandiblePlayerController({super.key});

  @override
  State<ExpandiblePlayerController> createState() =>
      _ExpandiblePlayerControllerState();
}

class _ExpandiblePlayerControllerState
    extends State<ExpandiblePlayerController> {
  late DraggableScrollableController _draggableController;
  bool _isdraggableOnMaxheight = false;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  void setDraggableAutomaticPosition() {
    final double currentSize = _draggableController.size;

    if (currentSize >= 0.3) {
      _draggableController.animateTo(0.9,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);

      setState(() {
        _isdraggableOnMaxheight = true;
      });
    } else {
      _draggableController.animateTo(0.08,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack);
      setState(() {
        _isdraggableOnMaxheight = false;
      });
    }

    setState(() {
      _isScrolling = false;
    });
  }

  void expandDraggableToMaxSize() {
    _draggableController.animateTo(0.9,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);

    setState(() {
      _isdraggableOnMaxheight = true;
    });
  }

  void collapseDraggableToMinSize() {
    _draggableController.animateTo(0.08,
        duration: const Duration(milliseconds: 600), curve: Curves.easeOutBack);
    setState(() {
      _isdraggableOnMaxheight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.08,
        minChildSize: 0.08,
        maxChildSize: 0.9,
        controller: _draggableController,
        builder: (BuildContext context, ScrollController scrollController) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  _isScrolling == false) {
                setState(() {
                  _isScrolling = true;
                });
                setDraggableAutomaticPosition();
              }

              return true;
            },
            child: Container(
                decoration: BoxDecoration(
                    color: _isdraggableOnMaxheight
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                    controller: scrollController,
                    child: ExpandiblePlayerSamallContent(
                      expandDraggableToMaxSize: expandDraggableToMaxSize,
                    ))),
          );
        });
  }
}
