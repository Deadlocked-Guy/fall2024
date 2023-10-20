import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../src/media.dart';
import '../src/video.dart';
import '../src/photo.dart';
import '../src/conversation.dart';
import '../main.dart';
import 'dart:io';

import 'package:cogniopenapp/src/database/model/media.dart' as database_media;
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';

class GalleryData {
  static final GalleryData _instance = GalleryData._internal();
  static final Directory photosDirectory =
      DirectoryManager.instance.photosDirectory;
  static final Directory videosDirectory =
      DirectoryManager.instance.videosDirectory;
  static final Directory audiosDirectory =
      DirectoryManager.instance.audiosDirectory;
  static final Directory transcriptsDirectory =
      DirectoryManager.instance.transcriptsDirectory;
  static final Directory videoStillsDirectory =
      DirectoryManager.instance.videoStillsDirectory;
  static final Directory videoResponsesDirectory =
      DirectoryManager.instance.videoResponsesDirectory;
  static String mostRecentVideoPath = "";
  static String mostRecentVideoName = "";
  static List<String> processedImages = [];

  GalleryData._internal() {
    print("Internal gallery data created");
    _initializeData();
  }

  void _initializeData() async {
    getAllPhotos();
    getAllVideos();
    _setMostRecentVideo();
    _initializeMedia(); // temporary db testing
  }

  // temporary db testing:
  Future<List<database_media.Media>> _initializeMedia() async {
    final audios = await AudioRepository.instance.readAll();
    final photos = await PhotoRepository.instance.readAll();
    final videos = await VideoRepository.instance.readAll();

    for (var audio in audios) {
      print(audio.toJson());
    }
    for (var photo in photos) {
      print(photo.toJson());
    }
    for (var video in videos) {
      print(video.toJson());
    }

    return [...audios, ...photos, ...videos];
  }

  factory GalleryData() {
    return _instance;
  }

  static List<Media> allMedia = [];

  static List<Media> getAllMedia() {
    return allMedia;
  }

  void getAllPhotos() async {
    if (photosDirectory.existsSync()) {
      List<FileSystemEntity> files = photosDirectory.listSync();

      for (var file in files) {
        if (file is File) {
          Photo photo = Photo(
            Image.file(file),
            Media(
              title: '<placeholder title>',
              description: '<placeholder title>',
              tags: ['<placeholder tag>'],
              timeStamp: DateTime.parse(getFileTimestamp(file.path)),
              storageSize: file.lengthSync(),
              isFavorited: false,
            ),
          );
          allMedia.add(photo);
        }
      }
    }

    allMedia.add(Video(
      '2:30', // Duration
      true, // Auto-delete
      [
        IdentifiedItem(
          'Item 1',
          DateTime.now(), // Time spotted
          Image.network(
            'https://www.example.com/item1.jpg', // Item image URL
          ),
        ),
        IdentifiedItem(
          'Item 2',
          DateTime.now()
              .subtract(Duration(days: 1)), // Time spotted (1 day ago)
          Image.network(
            'https://www.example.com/item2.jpg', // Item image URL
          ),
        ),
      ],
      Image.network(
          'https://cdn.fstoppers.com/styles/article_med/s3/media/2020/05/18/exploration_is_key_to_making_unique_landscape_photos_01.jpg'),
      Media(
        title: 'Test Video',
        description: 'This is a placeholder for a video',
        tags: ['video', 'test'],
        timeStamp: DateTime.now(),
        storageSize: 4096,
        isFavorited: false,
      ), // Associated media (in this case, a photo)
    ));

    allMedia.add(Conversation(
        "A test conversation",
        Media(
          title: "Conversation",
          description: "This is a sample conversation",
          tags: ["sample", "conversation"],
          timeStamp: DateTime(2023, 10, 5),
          storageSize: 2048, // 2 KB
          isFavorited: true,
        )));
  }

  static void _setMostRecentVideo() async {
    if (videosDirectory.existsSync()) {
      List<FileSystemEntity> files = videosDirectory.listSync();
      print("Most recently recorded video:");
      print(files.last.path);
      mostRecentVideoName = getFileNameForAWS(files.last.path);
      mostRecentVideoPath = files.last.path;
    }
  }

  void getAllVideos() async {
    if (videosDirectory.existsSync()) {
      List<FileSystemEntity> files = videosDirectory.listSync();

      for (var file in files) {
        if (file is File) {
          //print("VIDEO PATH PLEASE");
          //print(file.path);
          /* Photo photo = Photo(
            Image.file(file),
            Media(
              title: '<placeholder title>',
              description: '<placeholder title>',
              tags: ['<placeholder tag>', 'purple', 'pink'],
              timeStamp: DateTime.parse(getFileTimestamp(file.path)),
              storageSize: file.lengthSync(),
              isFavorited: false,
            ),
          );
          allMedia.add(photo); */
        }
      }
    }
    //printDirectoriesAndContents(videos);

    //TO DO POPULATE WITH THE VIDEO STUFF
  }

  void printDirectoriesAndContents(Directory directory, {int depth = 0}) {
    final prefix = '  ' * depth;
    print('$prefix${directory.path}/'); // Print the current directory

    try {
      final entities = directory.listSync(); // List the directory's contents

      for (final entity in entities) {
        if (entity is File) {
          print('$prefix  - ${entity.uri.pathSegments.last}'); // Print file
        } else if (entity is Directory) {
          printDirectoriesAndContents(entity,
              depth: depth + 1); // Recursively print subdirectory
        }
      }
    } catch (e) {
      print('$prefix  Error: $e');
    }
  }

  static String getFileTimestamp(String filePath) {
    // Get the file name from the full file path
    String fileName = path.basename(filePath);

    // Find the last dot (.) in the file name to separate the extension
    int dotIndex = fileName.lastIndexOf('.');

    String newName = fileName.replaceFirst("_", " ");

    if (dotIndex != -1) {
      // Return the file name without the extension
      return newName.substring(0, dotIndex);
    } else {
      // If there's no dot in the file name, return the entire name
      return newName;
    }
  }

  // TODO: Get better logic
  static getFileNameForAWS(String filePath) {
    // Get the file name from the full file path
    String fileName = path.basename(filePath);

    String partOne = fileName.replaceAll(" ", "_");

    String partTwo = partOne.replaceAll(":", "_");

    if (('.'.allMatches(partTwo).length > 1)) {
      return partTwo.replaceFirst(".", "_");
    }

    return partTwo;
  }

  static Future<Image> getThumbnail(String vidPath, int timesStamp) async {
    //print("Video path for frame is ${vidPath}");
    //print("timesStamp for frame is ${timesStamp}");

    String newFile =
        "${videoStillsDirectory.path}/${path.basename(vidPath)}-${timesStamp}.png";

    if (processedImages.contains(newFile)) {
      return Image.file(File(newFile));
    }

    processedImages.add(newFile); // Add the image if not added already

    try {
      String newPath = "${videoStillsDirectory.path}/";
      String? thumbPath = await VideoThumbnail.thumbnailFile(
        video: vidPath,
        thumbnailPath: newPath,
        imageFormat:
            ImageFormat.PNG, // You can use other formats like JPEG, etc.
        timeMs: timesStamp,
      );

      if (thumbPath != null) {
        // You can now load the image from the thumbnailPath and display it in your Flutter app.
        // For example, using the Image widget:
        File renamed = await File(thumbPath).rename(newFile);
        return Image.file(renamed);
      }
    } catch (e) {
      print("Error generating thumbnail: $e");
    }
    // REturn this to signfiy an erro
    return Image.network(
        "https://media.istockphoto.com/id/1349592578/de/vektor/leeres-warnschild-und-vorfahrtsschild-an-einem-mast-vektorillustration.webp?s=2048x2048&w=is&k=20&c=zmhLi9Ot96KXUe1OLd3dGNYJk0KMZZBQl39iQf6lcMk=");
  }
}
