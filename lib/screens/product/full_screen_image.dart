import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  const FullScreenImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imageUrl))),
        ),
      ),
    );
    // return Scaffold(
    //     body: GestureDetector(
    //   onTap: () {
    //     Navigator.pop(context);
    //   },
    //   child: Scaffold(
    //       backgroundColor: blackOpacity,
    //       body: Center(
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [const Icon(Icons.close), Image.network(imageUrl)]),
    //       )),
    // ));
  }
}
