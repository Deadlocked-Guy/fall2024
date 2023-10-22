import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:flutter/material.dart';

class UiUtils {
  static IconData getMediaIconData(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.audio:
        return Icons.chat;
      case MediaType.photo:
        return Icons.photo;
      case MediaType.video:
        return Icons.video_camera_back;
      default:
        throw Exception('Unsupported media type: $mediaType');
    }
  }
}
