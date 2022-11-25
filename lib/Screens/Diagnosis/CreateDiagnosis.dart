import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/DiagnosisInfo.dart';
import 'package:medical_app/classes/DiagnosisMedicineInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'package:http/http.dart' as http;
import '../../BackEndURL.dart';
import 'dart:convert';

class CreateDiagnosis extends StatefulWidget {
  const CreateDiagnosis({Key? key}) : super(key: key);

  @override
  _CreateDiagnosisState createState() => _CreateDiagnosisState();
}

class _CreateDiagnosisState extends State<CreateDiagnosis> {

  String consultationId = "";
  String prescriptionId = "";
  TextEditingController diagnosisInput = TextEditingController(text: "");
  bool doneButtonClicked = false;
  bool valuesInitialized = false;
  late DiagnosisInfo diagnosisInfo;


  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    consultationId = arguments['id'];
    if (arguments['diagnosis'] != null && !valuesInitialized){
      diagnosisInfo = arguments['diagnosis'];
      diagnosisInput = TextEditingController(text: diagnosisInfo.diagnosis);
      prescriptionId = diagnosisInfo.id;
      valuesInitialized = true;
    }


    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.diagnosisInformation,style: TextStyle(color: Colors.black),),
        ),
        body: FinalDiagnosis(),
        bottomNavigationBar: DoneButton()
    );
  }

  Widget FinalDiagnosis(){
    return MyContainer.anotherConstructor(
      Text(AppLocalizations.of(context)!.diagnosis,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
      SizedBox(
        width: 250,
        height: MediaQuery.of(context).size.height/8,
        child: Center(
          child: TextField(
            controller: diagnosisInput,
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enter+" "+AppLocalizations.of(context)!.diagnosis,
              hintStyle: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: diagnosisInput.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
              ),
              focusedBorder:UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
              ),
            ),
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ),
      MediaQuery.of(context).size.height/2,
      MediaQuery.of(context).size.width,
    );
  }

  Widget DoneButton(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: doneButtonClicked? null: () async {
          setState(() {
            doneButtonClicked = true;
          });

          String? token = await storage.read(key: 'token');
          http.Response response;
          if (!valuesInitialized) {
            response = await http.post(
              Uri.parse(URL+'/api/prescription'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'advice': diagnosisInput.text,
                'consultation_id': consultationId,
              }),
            );
          }
          else{
            response = await http.put(
              Uri.parse(URL+'/api/prescription/'+prescriptionId),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'advice': diagnosisInput.text,
                'consultation_id': consultationId,
              }),
            );
          }

          if (response.statusCode == 201 || response.statusCode == 200){
            Map JsonResponse = jsonDecode(response.body);
            Map data = JsonResponse['data'];
            String id = data['id'].toString();
            String diagnosis = data['advice'].toString();
            DiagnosisInfo res;
            if (!valuesInitialized)
              res = DiagnosisInfo(id, diagnosis,[]);
            else {
              diagnosisInfo.id = id;
              diagnosisInfo.diagnosis = diagnosis;
              res = diagnosisInfo;
            }
            Navigator.pop(context,res);
          }

          setState(() {
            doneButtonClicked = false;
          });
        },
        child: doneButtonClicked? CircularProgressIndicator(color: Colors.white,):Text(AppLocalizations.of(context)!.done),
      ),
    );
  }
}
