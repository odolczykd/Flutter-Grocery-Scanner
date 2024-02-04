import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenImageOffline extends StatelessWidget {
  final List<int> image;
  const FullScreenImageOffline(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(
                Uint8List.fromList(image),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
