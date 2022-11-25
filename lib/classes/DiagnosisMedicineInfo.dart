class DiagnosisMedicineInfo{
  String id = "0";
  String medicineId = "";
  String optionId="";
  String duration="";

  DiagnosisMedicineInfo(this.id, this.medicineId, this.optionId, this.duration);

  bool compare(DiagnosisMedicineInfo d){
    return (d.id == this.id) && (d.medicineId == this.medicineId) && (d.optionId == this.optionId) && (d.duration == this.duration);
  }
}