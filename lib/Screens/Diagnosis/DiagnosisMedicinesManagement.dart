import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/DiagnosisInfo.dart';
import 'package:medical_app/classes/DiagnosisMedicineInfo.dart';
import 'package:medical_app/classes/MedicineCategoryInfo.dart';
import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/classes/MedicineOptionsInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'package:http/http.dart' as http;
import '../../BackEndURL.dart';
import 'dart:convert';

class DiagnosisMedicinesManagement extends StatefulWidget {
  const DiagnosisMedicinesManagement({Key? key}) : super(key: key);

  @override
  _DiagnosisMedicinesManagementState createState() => _DiagnosisMedicinesManagementState();
}

class _DiagnosisMedicinesManagementState extends State<DiagnosisMedicinesManagement> {

  List<MedicineCategoryInfo> allCategories = List.empty(growable: true);
  List<MedicineOptionsInfo> allOptions = List.empty(growable: true);
  Map<String,List<MedicineInfo> > allMedicines = {};

  bool dataIsFetched = false;
  bool valuesInitialized = false;

  late DiagnosisInfo diagnosisInfo;

  List <String> categories = [];
  List<DiagnosisMedicineInfo> diagnosisMedicines = [];
  List<DiagnosisMedicineInfo> initialDiagnosisMedicines = [];

  @override
  void initState() {
    super.initState();
    FetchData();
  }

  Future <void> FetchData() async {
    await Future.wait([
      getAllCategories(),
      getAllMedicines(),
      getAllOptions(),
    ]);
    setState(() {
      dataIsFetched = true;
    });
  }
  Future<void> getAllMedicines() async {
    allMedicines.clear();
    allMedicines["All Categories"] = [];
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/drug'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map JsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200){
      List<dynamic> data = JsonResponse['data'];
      for (int i=0;i<data.length;i++){
        Map <String,dynamic> x = data[i];
        String id = x['id'].toString();
        String genericname = x['genericName'].toString();
        String tradename = x['tradeName'].toString();
        String note = x['note'].toString();
        Map <String,dynamic> category = x['category'];
        String categoryId = category['id'].toString();
        String categoryName = category['name'].toString();
        MedicineInfo medicineInfo = new MedicineInfo(id, genericname,tradename,categoryName,categoryId,note);
        if (allMedicines[categoryName] == null)
          allMedicines[categoryName] = [];
        allMedicines[categoryName]!.add(medicineInfo);
        allMedicines["All Categories"]!.add(medicineInfo);
      }
    }
  }

  Future<void> getAllCategories() async {
    allCategories.clear();
    allCategories.add(MedicineCategoryInfo("0","All Categories"));
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/category'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map JsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200){
      List<dynamic> data = JsonResponse['data'];
      for (int i=0;i<data.length;i++){
        Map <String,dynamic> x = data[i];
        String id = x['id'].toString();
        String name = x['name'].toString();
        allCategories.add(new MedicineCategoryInfo(id, name));
      }
    }
  }

  Future<void> getAllOptions() async {
    allOptions.clear();
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/option'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map JsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200){
      List<dynamic> data = JsonResponse['data'];
      for (int i=0;i<data.length;i++){
        Map <String,dynamic> x = data[i];
        String id = x['id'].toString();
        String name = x['name'].toString();
        String comment = x['comment'].toString();
        allOptions.add(new MedicineOptionsInfo(id, name, comment));
      }
    }
    setState(() {
      dataIsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['diagnosis']!=null && !valuesInitialized) {
      diagnosisInfo = arguments['diagnosis'];
      initialDiagnosisMedicines.addAll(diagnosisInfo.medicines);
      diagnosisMedicines.addAll(diagnosisInfo.medicines);
      for (int i=0;i<diagnosisInfo.medicines.length;i++)
        categories.add("All Categories");
      valuesInitialized = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.medicineEditing,style: TextStyle(color: Colors.black),),
        ),
        body: dataIsFetched == false ? Center(child: CircularProgressIndicator(),) : ListView.builder(
          itemCount: diagnosisMedicines.length+1,
          itemBuilder: (context, index) {
            if (index == diagnosisMedicines.length)
              return Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide (color: Colors.black, width: 1)),
                ),
                child: IconButton(onPressed: (){
                  setState(() {
                    categories.add("All Categories");
                    diagnosisMedicines.add(DiagnosisMedicineInfo("0","","",""));
                  });
                },
                icon: Icon(Icons.add_circle,size: 60,color: Colors.blueAccent,),
            ),
              );
            return Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide (color: Colors.black, width: 1)),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          showAlertDialog(context,index);
                        },
                        child: Icon(Icons.remove_circle,color: Colors.red,size: 40,),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                          children: [
                            SelectMedicineCategory(index),
                            SelectMedicine(index),
                            SelectOption(index),
                            MedicineTakingDuration(index),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: submit,
        child: Icon(Icons.done),
      ),
    );
  }

  void submit(){
    for (int i=0;i<diagnosisMedicines.length;i++){
      if (diagnosisMedicines[i].id == "0")
        addDrug(diagnosisMedicines[i]);
    }
    for (int j=0;j<initialDiagnosisMedicines.length;j++) {
      bool deleted = true;
      for (int i=0;i<diagnosisMedicines.length;i++) {
        if (initialDiagnosisMedicines[j].compare(diagnosisMedicines[i])) {
          deleted = false;
          break;
        }
        else if (initialDiagnosisMedicines[j].id == diagnosisMedicines[i].id) {
          deleted = false;
          editDrug(diagnosisMedicines[i]);
          break;
        }
      }
      if (deleted)
        deleteDrug(initialDiagnosisMedicines[j]);
    }
    // TODO: Update DiagnosisInfo.medicines => POP Navigator and return DiagnosisInfo
  }

  void addDrug(DiagnosisMedicineInfo d) async {
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.post(
      Uri.parse( URL+ '/api/prescription/'+diagnosisInfo.id+'/drug'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': '*/*',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'medication_option_id': d.optionId,
        'drug_id': d.medicineId,
        'duration': d.duration
      })
    );
    Map JsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200){
      Map data = JsonResponse['data'];
      // TODO: update object d with data
    }
    else {
      print(response.body);
      print(response.statusCode);
    }
  }

  void editDrug(DiagnosisMedicineInfo d){
    // TODO: edit drug
  }

  void deleteDrug(DiagnosisMedicineInfo d) async {
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.delete(
        Uri.parse( URL+ '/api/prescription/'+diagnosisInfo.id+'/drug/'+d.id),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
    );
    if (response.statusCode == 200){
      print('deleted successfully');
    }
    else {
      print(response.body);
      print(response.statusCode);
    }
  }

  showAlertDialog(BuildContext context,int index) {
    Widget cancelButton = TextButton(
      child: Text(AppLocalizations.of(context)!.no),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppLocalizations.of(context)!.yes),
      onPressed:  ()  {
        setState(() {
          diagnosisMedicines.removeAt(index);
        });
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.delete),
      content: Text(AppLocalizations.of(context)!.areYouSureYouWantTo+AppLocalizations.of(context)!.delete+" "+AppLocalizations.of(context)!.thisMedicine+"?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget SelectMedicineCategory(int index){
    return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(color: MyGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
            fillColor: MyGreyColor,
            prefixIcon: Icon(null),
            filled: true,
          ),
          isExpanded: true,
          value: categories[index]=="" ? null: categories[index],
          items: allCategories.map((MedicineCategoryInfo items) {
            return DropdownMenuItem(
              value: items.name,
              child: Text(items.name),
            );
          }).toList(),
          onChanged: (selectedValue){
            setState(() {
              diagnosisMedicines[index].medicineId = "";
              categories[index] = selectedValue.toString();

            });
          },
          dropdownColor: Colors.white,
        ),
    );
  }

  Widget SelectMedicine(int index){
    return Padding(
        padding: const EdgeInsets.all(10),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(color: MyGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
            fillColor: MyGreyColor,
            hintText: AppLocalizations.of(context)!.chooseAMedicine,
            prefixIcon: Icon(null),
            filled: true,
          ),
          isExpanded: true,
          value: diagnosisMedicines[index].medicineId=="" ? null: diagnosisMedicines[index].medicineId,
          items: allMedicines[categories[index]]!.map((MedicineInfo items) {
            return DropdownMenuItem(
              value: items.id,
              child: Text(items.tradeName),
            );
          }).toList(),
          onChanged: (selectedValue){
            setState(() {
              diagnosisMedicines[index].medicineId = selectedValue.toString();
            });
          },
          dropdownColor: Colors.white,
        ),
    );
  }

  Widget SelectOption(int index){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          enabledBorder: new UnderlineInputBorder(
            borderSide: BorderSide(color: MyGreyColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          fillColor: MyGreyColor,
          hintText: AppLocalizations.of(context)!.medicineTakingOptions,
          prefixIcon: Icon(null),
          filled: true,
        ),
        isExpanded: true,
        value: diagnosisMedicines[index].optionId=="" ? null: diagnosisMedicines[index].optionId,
        items: allOptions.map((MedicineOptionsInfo items) {
          return DropdownMenuItem(
            value: items.id,
            child: Text(items.name),
          );
        }).toList(),
        onChanged: (selectedValue){
          setState(() {
            diagnosisMedicines[index].optionId = selectedValue.toString();
          });
        },
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget MedicineTakingDuration(int index){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: TextFormField(
            initialValue: diagnosisMedicines[index].duration,
            cursorColor: Colors.black,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterYour+AppLocalizations.of(context)!.medicineTakingDuration,
              hintStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              enabledBorder: InputBorder.none,
              focusedBorder:InputBorder.none,
              prefixIcon: Icon(null),
              filled: true,
              fillColor: MyGreyColor
            ),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.number,
            onChanged: (val){
              setState(() {
                diagnosisMedicines[index].duration = val;
              });
            },
          ),
        ),
      ),
    );
  }
}