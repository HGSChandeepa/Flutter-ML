import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 245, 222),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imagePath == null
          ? const Center(
              child: Icon(
                Icons.image,
                size: 300,
                color: Colors.orangeAccent,
              ),
            )
          : Image.file(
              File(imagePath!),
              fit: BoxFit.contain,
            ),
    );
  }
}
