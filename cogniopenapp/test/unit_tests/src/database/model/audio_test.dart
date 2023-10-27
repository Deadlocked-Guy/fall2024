import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int id = 1;
  const String title = 'Test Title';
  const String description = 'Test Description';
  const List<String> tags = ['Tag1', 'Tag2'];
  final DateTime timestamp = DateTime.now();
  const int storageSize = 1000;
  const bool isFavorited = true;
  const String audioFileName = 'test_audio.mp3';
  const String transcriptFileName = 'test_transcript.txt';
  const String summary = 'Test Summary';

  group('Audio', () {
    // Audio constructor tests:

    test(
        'Audio constructor (with all parameters provided) should create an Audio object and initialize values correctly',
        () {
      final Audio audio = Audio(
        id: id,
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        storageSize: storageSize,
        isFavorited: isFavorited,
        audioFileName: audioFileName,
        transcriptFileName: transcriptFileName,
        summary: summary,
      );

      expect(audio.id, id);
      expect(audio.mediaType, MediaType.audio);
      expect(audio.title, title);
      expect(audio.description, description);
      expect(audio.tags, tags);
      expect(audio.timestamp, timestamp);
      expect(audio.storageSize, storageSize);
      expect(audio.isFavorited, isFavorited);
      expect(audio.audioFileName, audioFileName);
      expect(audio.transcriptFileName, transcriptFileName);
      expect(audio.summary, summary);
    });

    test(
        'Audio constructor (with only required parameters provided) should create an Audio object and initialize values correctly',
        () {
      final Audio audio = Audio(
        id: id,
        title: title,
        timestamp: timestamp,
        storageSize: storageSize,
        isFavorited: isFavorited,
        audioFileName: audioFileName,
      );

      expect(audio.id, id);
      expect(audio.mediaType, MediaType.audio);
      expect(audio.title, title);
      expect(audio.description, isNull);
      expect(audio.tags, isNull);
      expect(audio.timestamp, timestamp);
      expect(audio.storageSize, storageSize);
      expect(audio.isFavorited, isFavorited);
      expect(audio.audioFileName, audioFileName);
      expect(audio.transcriptFileName, isNull);
      expect(audio.summary, isNull);
    });

    // Audio.fromJson() tests:

    test(
        'Audio.fromJson should correctly create an Audio object from JSON (with all field values)',
        () {
      final Map<String, Object?> json = {
        MediaFields.id: id,
        MediaFields.title: title,
        MediaFields.description: description,
        MediaFields.tags: tags.join(','),
        MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
        MediaFields.storageSize: storageSize,
        MediaFields.isFavorited: 1,
        AudioFields.audioFileName: audioFileName,
        AudioFields.transcriptFileName: transcriptFileName,
        AudioFields.summary: summary,
      };

      final Audio audio = Audio.fromJson(json);

      expect(audio.id, id);
      expect(audio.mediaType, MediaType.audio);
      expect(audio.title, title);
      expect(audio.description, description);
      expect(audio.tags, tags);
      expect(
          audio.timestamp,
          DateTime.fromMillisecondsSinceEpoch(
              timestamp.toUtc().millisecondsSinceEpoch,
              isUtc: true));
      expect(audio.storageSize, storageSize);
      expect(audio.isFavorited, isFavorited);
      expect(audio.audioFileName, audioFileName);
      expect(audio.transcriptFileName, transcriptFileName);
      expect(audio.summary, summary);
    });

    test(
      'Audio.fromJson should correctly create an Audio object from JSON (with non-nullable field values only)',
      () {
        final Map<String, Object?> json = {
          MediaFields.id: id,
          MediaFields.title: title,
          MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
          MediaFields.storageSize: storageSize,
          MediaFields.isFavorited: 1,
          AudioFields.audioFileName: audioFileName,
        };

        final Audio audio = Audio.fromJson(json);

        expect(audio.id, id);
        expect(audio.mediaType, MediaType.audio);
        expect(audio.title, title);
        expect(audio.description, isNull);
        expect(audio.tags, isNull);
        expect(
            audio.timestamp,
            DateTime.fromMillisecondsSinceEpoch(
                timestamp.toUtc().millisecondsSinceEpoch,
                isUtc: true));
        expect(audio.storageSize, storageSize);
        expect(audio.isFavorited, isFavorited);
        expect(audio.audioFileName, audioFileName);
        expect(audio.transcriptFileName, isNull);
        expect(audio.summary, isNull);
      },
    );

    test(
      'Audio.fromJson should throw a FormatException when given invalid JSON',
      () {
        final Map<String, Object?> json = {};

        expect(() => Audio.fromJson(json), throwsA(isA<FormatException>()));
      },
    );
  });

  // Audio.toJson() tests:

  test(
    'Audio.toJson should correctly serialize an Audio object (with all field values) to JSON',
    () {
      final Audio audio = Audio(
        id: id,
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        storageSize: storageSize,
        isFavorited: isFavorited,
        audioFileName: audioFileName,
        transcriptFileName: transcriptFileName,
        summary: summary,
      );

      final Map<String, Object?> json = audio.toJson();

      expect(json, {
        MediaFields.id: id,
        MediaFields.title: title,
        MediaFields.description: description,
        MediaFields.tags: tags.join(','),
        MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
        MediaFields.storageSize: storageSize,
        MediaFields.isFavorited: 1,
        AudioFields.audioFileName: audioFileName,
        AudioFields.transcriptFileName: transcriptFileName,
        AudioFields.summary: summary,
      });
    },
  );

  test(
    'Audio.toJson should correctly serialize an Audio object (with non-nullable field values only) to JSON',
    () {
      final Audio audio = Audio(
        id: id,
        title: title,
        timestamp: timestamp,
        storageSize: storageSize,
        isFavorited: isFavorited,
        audioFileName: audioFileName,
      );

      final Map<String, Object?> json = audio.toJson();

      expect(json, {
        MediaFields.id: id,
        MediaFields.title: title,
        MediaFields.description: null,
        MediaFields.tags: null,
        MediaFields.timestamp: timestamp.toUtc().millisecondsSinceEpoch,
        MediaFields.storageSize: storageSize,
        MediaFields.isFavorited: 1,
        AudioFields.audioFileName: audioFileName,
        AudioFields.transcriptFileName: null,
        AudioFields.summary: null,
      });
    },
  );
}
