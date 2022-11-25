import 'package:medical_app/classes/DiagnosisMedicineInfo.dart';

class DiagnosisInfo{
  String id = "";
  String diagnosis = "";
  List <DiagnosisMedicineInfo> medicines = [];
  DiagnosisInfo(this.id, this.diagnosis,this.medicines);
}