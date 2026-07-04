import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<File?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final xFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (xFile == null) return null;
      return File(xFile.path);
    } catch (e) {
      return null;
    }
  }

  Future<List<File>> pickMultipleImages({int maxImages = 10}) async {
    try {
      final xFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: maxImages,
      );
      return xFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<File?> compressImage(File file) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        file.path.replaceAll('.jpg', '_compressed.jpg'),
        quality: 70,
        minWidth: 1024,
        minHeight: 1024,
      );
      if (result == null) return file;
      return File(result.path);
    } catch (e) {
      return file;
    }
  }

  Future<List<String>> uploadImages({
    required List<File> images,
    required String folder,
    String? userId,
  }) async {
    final List<String> urls = [];
    final uuid = const Uuid();

    for (final image in images) {
      final compressed = await compressImage(image);
      final fileName = '${uuid.v4()}.jpg';
      final ref = _storage.ref('$folder/$userId/$fileName');
      final task = ref.putFile(compressed ?? image);
      final snapshot = await task;
      final url = await snapshot.ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  Future<String> uploadSingleImage({
    required File image,
    required String folder,
    String? userId,
  }) async {
    final compressed = await compressImage(image);
    final uuid = const Uuid();
    final fileName = '${uuid.v4()}.jpg';
    final ref = _storage.ref('$folder/$userId/$fileName');
    final task = ref.putFile(compressed ?? image);
    final snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Ignore deletion errors
    }
  }

  Stream<double> uploadWithProgress({
    required File image,
    required String folder,
    String? userId,
  }) {
    final uuid = const Uuid();
    final fileName = '${uuid.v4()}.jpg';
    final ref = _storage.ref('$folder/$userId/$fileName');
    final task = ref.putFile(image);
    final controller = StreamController<double>.broadcast();

    task.snapshotEvents.listen(
      (snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        controller.add(progress);
      },
      onError: (Object error) => controller.addError(error),
      onDone: () async {
        await ref.getDownloadURL();
        controller.add(1.0);
        await controller.close();
      },
    );

    return controller.stream;
  }
}
