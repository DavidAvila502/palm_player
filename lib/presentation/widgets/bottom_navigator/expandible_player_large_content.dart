import 'package:flutter/material.dart';

class ExpandiblePlayerLargeContent extends StatefulWidget {
  const ExpandiblePlayerLargeContent({super.key});

  @override
  State<ExpandiblePlayerLargeContent> createState() =>
      _ExpandiblePlayerLargeContentState();
}

class _ExpandiblePlayerLargeContentState
    extends State<ExpandiblePlayerLargeContent> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      children: [Text('LARGE CONTENT.')],
    ));
  }
}
