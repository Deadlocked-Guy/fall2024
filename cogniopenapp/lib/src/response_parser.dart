// ignore_for_file: avoid_print

import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/data_service.dart';
import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/format_utils.dart';
import 'dart:core';
import 'dart:io';

class ResponseParser {
  static VideoResponse? getRequestedResponse(String searchTitle) {
    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      if (DataService.instance.responseList[i].title == searchTitle) {
        return DataService.instance.responseList[i];
      }
    }
    return null;
  }

  static Future<void> convertResponseToLocalSignificantObject(
      VideoResponse response) async {
    String sourceFilePath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    File sourceFile = File(sourceFilePath);

    if (await sourceFile.exists()) {
      String fileName =
          FileManager.getThumbnailFileName(sourceFilePath, response.timestamp);
      String fullPath =
          "${DirectoryManager.instance.videoStillsDirectory.path}/$fileName";
      File destinationFile = File(fullPath);

      DataService.instance.addSignificantObject(
          timestamp: response.timestamp,
          left: response.left,
          top: response.top,
          width: response.width,
          height: response.height,
          imageFile: destinationFile);
    } else {
      print("Source file does not exist: $sourceFilePath");
    }
  }

  static List<VideoResponse> getRequestedResponseList(String searchTitle,
      {int filterInterval = 0}) {
    List<VideoResponse> responses = [];
    String previousFile = "";
    int previousTimeStamp = 0;

    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      VideoResponse response = DataService.instance.responseList[i];

      if (response.title == searchTitle) {
        if (filterInterval == 0) {
          // Do nothing, but skip the next else if
        } else if (previousFile == response.referenceVideoFilePath &&
            response.timestamp - previousTimeStamp > -filterInterval) {
          // Skip this response if the file is the same and the timestamp difference is less than the repeat interval.
          continue;
        }

        responses.add(DataService.instance.responseList[i]);

        // Update previousFile and previousTimeStamp for the next iteration.
        previousFile = response.referenceVideoFilePath;
        previousTimeStamp = response.timestamp;
      }
    }
    return responses;
  }

  static List<VideoResponse> getListOfResponses() {
    List<String> trackedTitles = [];
    List<VideoResponse> responses = [];
    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      String title = DataService.instance.responseList[i].title;
      if (!trackedTitles.contains(title)) {
        trackedTitles.add(title);
        responses.add(DataService.instance.responseList[i]);
      }
    }
    return responses;
  }

  static Future<Image> getThumbnail(VideoResponse response) async {
    String fullPath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    return await FileManager.getThumbnail(fullPath, response.timestamp);
  }

  static String getTimeStampFromResponse(VideoResponse response) {
    String fullPath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    String time = FileManager.getFileTimestamp(fullPath);
    DateTime parsedDate = DateTime.parse(time);
    return FormatUtils.getDateString(
        parsedDate.add(Duration(milliseconds: response.timestamp)));
  }

  static String getHoursFromResponse(VideoResponse response) {
    String fullPath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    String time = FileManager.getFileTimestamp(fullPath);
    DateTime parsedDate = DateTime.parse(time);
    return FormatUtils.getTimeString(
        parsedDate.add(Duration(milliseconds: response.timestamp)));
  }
}
