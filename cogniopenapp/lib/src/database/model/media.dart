import 'package:cogniopenapp/src/database/model/media_type.dart';

abstract class MediaFields {
  static final List<String> values = [
    id,
    title,
    description,
    tags,
    timestamp,
    storageSize,
    isFavorited,
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String tags = 'tags';
  static const String timestamp = 'timestamp';
  static const String storageSize = 'storageSize';
  static const String isFavorited = 'isFavorited';
}

abstract class Media {
  final int? id;
  final MediaType mediaType;
  final String title;
  final String? description;
  final List<String>? tags;
  final DateTime timestamp;
  final int storageSize;
  bool isFavorited;

  Media({
    this.id,
    required this.mediaType,
    required this.title,
    this.description,
    this.tags,
    required this.timestamp,
    required this.storageSize,
    required this.isFavorited,
  });

  Media copy({
    int? id,
    String title,
    String? description,
    List<String>? tags,
    DateTime? timestamp,
    int? storageSize,
    bool? isFavorited,
  });

  Map<String, Object?> toJson() => {
        MediaFields.id: id,
        MediaFields.title: title,
        MediaFields.description: description,
        MediaFields.tags: tags?.join(','),
        MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
        MediaFields.storageSize: storageSize,
        MediaFields.isFavorited: isFavorited ? 1 : 0,
      };

  static Media fromJson(Map<String, Object?> json) {
    throw UnimplementedError();
  }
}
