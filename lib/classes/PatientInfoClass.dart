

class PatientInfo {
  String id="";
  String name="";
  String birthDate="";
  String phone="";
  String work="";
  String address="";
  String gender="";
  String martial="";

  PatientInfo(this.id,this.name,this.birthDate,this.phone,this.work,this.address,this.gender,this.martial);

  String calculateAge(){
    DateTime b = DateTime.parse(birthDate);
    DateTime now = DateTime.now();
    int age = now.year - b.year;
    return age.toString();
  }
}