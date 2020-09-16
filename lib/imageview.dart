import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  String id;

  ImageView(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Фото"),
      ),
      body: Center(
        child: Image.network(id),
      ),
    );
  }
}
