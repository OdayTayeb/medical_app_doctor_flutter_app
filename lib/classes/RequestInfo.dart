class RequestInfo{
  String id = "";
  int index = 0;
  String comment = "";
  List<String> bloodTests=List.empty(growable: true);
  List <String> radioTests = List.empty(growable: true);
  bool isFulfilled = false;

  RequestInfo(this.id,this.index, this.comment, this.bloodTests, this.radioTests,this.isFulfilled);

  void incrementIndex(){index++;}

  void decrementIndex(){index--;}
}