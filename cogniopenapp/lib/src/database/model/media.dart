import 'package:cogniopenapp/src/database/model/media_type.dart';

abstract class MediaFields {
  static final List<String> values = [
    id,
    mediaType,
    title,
    description,
    tags,
    timestamp,
    fileName,
    storageSize,
    isFavorited,
  ];

  static const String id = '_id';
  static const String mediaType = 'mediaType';
  static const String title = 'title';
  static const String description = 'description';
  static const String tags = 'tags';
  static const String timestamp = 'timestamp';
  static const String fileName = 'fileName';
  static const String storageSize = 'storageSize';
  static const String isFavorited = 'isFavorited';
}

abstract class Media {
  final int? id;
  final MediaType mediaType;
  final String? title;
  final String? description;
  final List<String>? tags;
  final DateTime timestamp;
  final String fileName;
  final int storageSize;
  final bool isFavorited;

  Media({
    this.id,
    required this.mediaType,
    this.title,
    this.description,
    this.tags,
    required this.timestamp,
    required this.fileName,
    required this.storageSize,
    required this.isFavorited,
  });

  Media copy({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    DateTime? timestamp,
    String? fileName,
    int? storageSize,
    bool? isFavorited,
  });

  Map<String, Object?> toJson() => {
        MediaFields.id: id,
        MediaFields.title: title,
        MediaFields.description: description,
        MediaFields.tags: tags?.join(','),
        MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
        MediaFields.fileName: fileName,
        MediaFields.storageSize: storageSize,
        MediaFields.isFavorited: isFavorited ? 1 : 0,
      };

  static Media fromJson(Map<String, Object?> json) {
    throw UnimplementedError();
  }
}
