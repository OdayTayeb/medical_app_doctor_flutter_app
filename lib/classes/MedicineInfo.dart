class MedicineInfo{
  String id="";
  String genericName="";
  String tradeName="";
  String category="";
  String categoryId = "";
  String note="";

  MedicineInfo.defaultConstructor();

  MedicineInfo(this.id,this.genericName,this.tradeName,this.category,this.categoryId,this.note);

  @override
  bool operator ==(Object other) {
    if (!(other is MedicineInfo))
      return false;
    MedicineInfo O = other as MedicineInfo;
    if (id == O.id && genericName == O.genericName && tradeName == O.tradeName && category == O.category && categoryId == O.categoryId && note == O.note)
      return true;
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  static MedicineInfo Copy(MedicineInfo m){
    MedicineInfo x = MedicineInfo.defaultConstructor();
    x.id = m.id;
    x.genericName = m.genericName;
    x.tradeName = m.tradeName;
    x.category = m.category;
    x.categoryId = m.categoryId;
    x.note = m.note;
    return x;
  }
}