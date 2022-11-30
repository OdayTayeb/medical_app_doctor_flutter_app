import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/classes/MedicineOptionsInfo.dart';

class DiagnosisMedicineInfo{
  String id = "0";
  MedicineInfo medicine = MedicineInfo.defaultConstructor();
  MedicineOptionsInfo option = MedicineOptionsInfo.defaultConstructor();
  String duration="";

  DiagnosisMedicineInfo.anotherConstructor();

  DiagnosisMedicineInfo(this.id, this.medicine, this.option, this.duration);

  @override
  bool operator ==(Object other) {
    if (! (other is DiagnosisMedicineInfo))
      return false;
    DiagnosisMedicineInfo O = other as DiagnosisMedicineInfo;
    if (id == O.id && medicine == O.medicine && option == O.option && duration == O.duration)
      return true;
    return false;
  }

  @override
  int get hashCode => super.hashCode;

  static DiagnosisMedicineInfo Copy(DiagnosisMedicineInfo d){
    DiagnosisMedicineInfo x = DiagnosisMedicineInfo.anotherConstructor();
    x.id = d.id;
    x.medicine = MedicineInfo.Copy(d.medicine);
    x.option = MedicineOptionsInfo.Copy(d.option);
    x.duration = d.duration;
    return x;
  }
}