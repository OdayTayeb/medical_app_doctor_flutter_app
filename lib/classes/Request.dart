class Request{
  String id="";
  String comment="";
  List <String> bloodTests = List.empty(growable: true);
  List <String> radioGraphs = List.empty(growable: true);
  DateTime createdAt = DateTime.now();

  Request(this.id, this.comment, this.bloodTests, this.radioGraphs, this.createdAt);
}