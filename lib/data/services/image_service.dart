import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static Future<List<XFile>> pickFromGallery({int limit = 1}) async {
    final picker = ImagePicker();
    return await picker.pickMultiImage(requestFullMetadata: false, limit: limit);
  }

  static Future<Uint8List?> cropAndCompressImage({required XFile file, required int sideWidth}) async {
    try {
      final list = await file.readAsBytes();

      final compressedImage =
          await FlutterImageCompress.compressWithList(list, minWidth: sideWidth, minHeight: sideWidth);

      final image = decodeImage(compressedImage)!;
      final cropWidth = image.width < image.height ? image.width : image.height;
      final x = image.width > cropWidth ? (image.width - cropWidth) ~/ 2 : 0;
      final y = image.height > cropWidth ? (image.height - cropWidth) ~/ 2 : 0;
      final croppedImage = copyCrop(image, x: x, y: y, width: cropWidth, height: cropWidth);

      return Uint8List.fromList(encodeJpg(croppedImage, quality: 90));
    } catch (_) {}

    return null;
  }
}
