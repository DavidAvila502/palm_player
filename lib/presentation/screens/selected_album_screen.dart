import 'package:flutter/material.dart';

class SelectedAlbumScreen extends StatelessWidget {
  const SelectedAlbumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Row(
          children: [
            SizedBox(
              height: 30,
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.white,
              size: 30,
            ),
            Text('Playing'),
          ],
        ),
        Center(
          child: Text('selected song screen'),
        )
      ],
    );
  }
}
