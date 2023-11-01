import 'package:flutter/material.dart';

class SignificantObject {
  String identifier;
  List<Image> referencePhotos;
  List<String> alternateNames;
  List<ResponseBoundingBox> boundingBoxes = [];

  SignificantObject(this.identifier, this.referencePhotos, this.alternateNames);
  //assumption that images in referencePhotos map 1:1 to entries in boundingPhotos
  //i.e., the first Image in referencePhotos is associated with the first ResponseBoundingBox in boundingBoxes and so forth
  SignificantObject.overloaded(this.identifier, this.referencePhotos,
      this.alternateNames, this.boundingBoxes);

  deleteImage() {}

  deleteAlternateName(String nameToRemove) {
    alternateNames.remove(nameToRemove);
  }

  addAlternateName(String newName) {
    alternateNames.add(newName);
  }

  updateSignificantObject(
      Image image, String alternativeName, ResponseBoundingBox boundingBox) {
    referencePhotos.add(image);
    addAlternateName(alternativeName);
    boundingBoxes.add(boundingBox);
  }

  String generateRekognitionManifest() {
    String bar = "";
    int i = 0;
    for (Image im in referencePhotos) {
      ResponseBoundingBox annotation = boundingBoxes[i];
      bar = '''{"source-ref": "s3://cogniopen-videos-test-david/$identifier-$i",
           "bounding-box": {"image_size": [{"width": ${im.width}, "height": ${im.height}, "depth": 3}],
           "annotations": [{ "class_id": 0,
           "top": ${(annotation.top * im.height!).toInt()}, "left": ${(annotation.left * im.width!).toInt()},
           "width": ${(annotation.width * im.width!).toInt()}, "height": ${(annotation.height * im.height!).toInt()}}]},
           "bounding-box-metadata": {"objects": [{"confidence": 1}], "class-map": {"0": "$identifier"},"type":
           "groundtruth/object-detection", "human-annotated": "yes", "creation-date": "2013-11-18T02:53:27"}}''';
      bar += bar;
    }
    return bar;
  }
}

class ResponseBoundingBox {
  double left;
  double top;
  double width;
  double height;

  ResponseBoundingBox(
      {required this.left,
      required this.top,
      required this.width,
      required this.height});

  @override
  String toString() {
    return 'ResponseBoundingBox{left: $left, top: $top, width: $width, height: $height}';
  }
}
