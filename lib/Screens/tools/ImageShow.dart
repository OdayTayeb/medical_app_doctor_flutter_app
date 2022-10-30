import 'package:flutter/material.dart';

class ImageShow extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    Image I = arguments['image'];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        elevation: 2,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
            child: InteractiveViewer(
              panEnabled: false,
              minScale: 1,
              maxScale: 4,
              child: I,
            ),
          ),
      ),
    );
  }
}
