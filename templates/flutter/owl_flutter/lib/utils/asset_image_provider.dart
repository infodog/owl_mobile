import 'dart:typed_data';
import 'dart:ui' as ui show Codec;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:multi_image_picker/asset.dart';

class ImagePickerAssetImage extends ImageProvider<ImagePickerAssetImage> {
  ImagePickerAssetImage({this.asset});
  Asset asset;
  @override
  Future<ImagePickerAssetImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ImagePickerAssetImage>(this);
  }

  @override
  ImageStreamCompleter load(ImagePickerAssetImage key) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key),
        scale: 1.0,
        informationCollector: (StringBuffer information) {
          information.writeln('Image provider: $this');
          information.write('Image key: $key');
        });
  }

  Future<ui.Codec> _loadAsync(ImagePickerAssetImage key) async {
    assert(key == this);
    await asset.requestThumbnail(1024, 1024, quality: 95);
    final Uint8List bytes = asset.imageData.buffer.asUint8List();
    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }
}
