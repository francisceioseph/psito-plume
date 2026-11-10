import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Pixels on their way to or from the clipboard: straight alpha, row by row.
@immutable
class ClipboardImage {
  const ClipboardImage({
    required this.width,
    required this.height,
    required this.rgba,
  });

  final int width;
  final int height;
  final Uint8List rgba;
}

/// Where copied pictures go, so that other programs can paste them.
abstract class ImageClipboard {
  Future<ClipboardImage?> read();
  Future<void> write(ClipboardImage image);
}

/// The system clipboard, through the runner (Linux and Windows). Elsewhere,
/// or if anything fails, it answers nothing and the program keeps its own
/// copy.
class SystemImageClipboard implements ImageClipboard {
  static const _channel = MethodChannel('psito/clipboard_image');

  @override
  Future<ClipboardImage?> read() async {
    try {
      final value = await _channel.invokeMapMethod<String, Object?>('read');
      if (value == null) return null;
      final width = value['width'] as int;
      final height = value['height'] as int;
      final rgba = value['rgba'] as Uint8List;
      if (rgba.length != width * height * 4) return null;
      return ClipboardImage(width: width, height: height, rgba: rgba);
    } on Object catch (error) {
      debugPrint('no image from the clipboard: $error');
      return null;
    }
  }

  @override
  Future<void> write(ClipboardImage image) async {
    try {
      await _channel.invokeMethod<void>('write', {
        'width': image.width,
        'height': image.height,
        'rgba': image.rgba,
      });
    } on Object catch (error) {
      debugPrint('the clipboard did not take the image: $error');
    }
  }
}

/// For the tests: a clipboard that only lives in memory.
class MemoryImageClipboard implements ImageClipboard {
  ClipboardImage? image;

  @override
  Future<ClipboardImage?> read() async => image;

  @override
  Future<void> write(ClipboardImage image) async => this.image = image;
}
