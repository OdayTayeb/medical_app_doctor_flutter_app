class MedicineOptionsInfo {
  String id="";
  String name="";
  String description="";

  MedicineOptionsInfo.defaultConstructor();

  MedicineOptionsInfo(this.id,this.name,this.description);

  @override
  bool operator ==(Object other) {
    if (!(other is MedicineOptionsInfo))
      return false;
    MedicineOptionsInfo O = other as MedicineOptionsInfo;
    if (id == O.id && name == O.name && description == O.description)
      return true;
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  static MedicineOptionsInfo Copy(MedicineOptionsInfo m){
    MedicineOptionsInfo x = MedicineOptionsInfo.defaultConstructor();
    x.id = m.id;
    x.name = m.name;
    x.description = m.description;
    return x;
  }
}