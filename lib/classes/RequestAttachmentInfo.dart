import 'package:flutter/foundation.dart';

class RequestAttachmentInfo{
  List <Uint8List> images = List.empty(growable: true);
  int index = 0;
  bool isFulfilled = false;

  RequestAttachmentInfo(this.images, this.index);

  void incrementIndex(){index++;}
  void decrementIndex(){index--;}
  void appendListOfImages(List <Uint8List> im){
    images.addAll(im);
  }


}