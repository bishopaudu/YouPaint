import 'dart:io';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();
  factory ShareService() => _instance;
  ShareService._internal();

  // Share drawing as image
  Future<void> shareImage({required File imageFile, String? title}) async {
    try {
      final xFile = XFile(imageFile.path);
      await Share.shareXFiles(
        [xFile],
        text: title ?? 'Check out my drawing from YouPaint!',
        subject: 'My Drawing',
      );
    } catch (e) {
      throw Exception('Failed to share image: $e');
    }
  }

  // Share drawing as video
  Future<void> shareVideo({required File videoFile, String? title}) async {
    try {
      final xFile = XFile(videoFile.path);
      await Share.shareXFiles(
        [xFile],
        text: title ?? 'Check out my drawing process from YouPaint!',
        subject: 'My Drawing Process',
      );
    } catch (e) {
      throw Exception('Failed to share video: $e');
    }
  }

  // Share multiple files
  Future<void> shareMultiple({required List<File> files, String? text}) async {
    try {
      final xFiles = files.map((file) => XFile(file.path)).toList();
      await Share.shareXFiles(
        xFiles,
        text: text ?? 'Check out my drawings from YouPaint!',
      );
    } catch (e) {
      throw Exception('Failed to share files: $e');
    }
  }

  // Share text only
  Future<void> shareText(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      throw Exception('Failed to share text: $e');
    }
  }
}
