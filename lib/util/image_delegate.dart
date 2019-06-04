import 'package:firebase_articles/services/storage.dart';
import 'compressor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:io';

class ArticleImage extends ZefyrImageDelegate {
  StorageToolKit storageToolKit = StorageToolKit();
  @override
  Widget buildImage(BuildContext context, String imageSource) {
    final image = NetworkImage(imageSource);
    return Image(
      image: image,
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Future<String> pickImage(source) async {
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) return null;

    CompressImage compressImage = CompressImage();
    File compressedFile = await compressImage.getCompressedImage(imageFile);

    final String imageUrl = await storageToolKit.uploadTask(compressedFile, false);
    return imageUrl;
  }
}
