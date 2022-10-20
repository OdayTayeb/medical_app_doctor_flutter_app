import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/BloodTestInfo.dart';
import 'package:medical_app/classes/MedicineOptionsInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import 'package:http/http.dart' as http;
import '../../SecureStorage.dart';
import '../../BackEndURL.dart';
import 'dart:convert';

class addMedicineOption extends StatefulWidget {
  const addMedicineOption({Key? key}) : super(key: key);

  @override
  State<addMedicineOption> createState() => _addMedicineOptionState();
}

class _addMedicineOptionState extends State<addMedicineOption> {

  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController commentController = TextEditingController(text: "");
  bool doneButtonClicked = false;

  bool valuesIsInit = false;
  late MedicineOptionsInfo info;

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['info'] != null && !valuesIsInit) {
      info = arguments['info'];
      nameController = TextEditingController(text: info.name);
      commentController = TextEditingController(text: info.description);
      valuesIsInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.medicineOptionInformation,style: TextStyle(color: Colors.black),),
      ),
      body:  Column(
        children: [
          Name(),
          Comment(),
          doneButton(),
        ],
      ),
    );
  }

  Widget Name(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.name,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: nameController,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter+" "+AppLocalizations.of(context)!.optionName,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: nameController.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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
            )
        )
    );
  }

  Widget Comment(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.comment,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: commentController,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterAComment,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: commentController.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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
            )
        )
    );
  }

  Widget doneButton(){
    return Expanded(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: doneButtonClicked? null: () async {
                setState(() {
                  doneButtonClicked = true;
                });
                String? token = await storage.read(key: 'token');
                http.Response response;
                if (!valuesIsInit) {
                  response = await http.post(
                    Uri.parse(URL + '/api/option'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Accept': '*/*',
                      'Connection': 'keep-alive',
                      'Accept-Encoding': 'gzip, deflate, br',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode(<String, String>{
                      "optionName": nameController.text,
                      "comment": commentController.text,
                    }),
                  );
                }
                else{
                  response = await http.put(
                    Uri.parse(URL + '/api/option/' + info.id),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Accept': '*/*',
                      'Connection': 'keep-alive',
                      'Accept-Encoding': 'gzip, deflate, br',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $token',
                    },
                    body: jsonEncode(<String, String>{
                      "optionName": nameController.text,
                      "comment": commentController.text,
                    }),
                  );
                }
                if (response.statusCode == 201 || response.statusCode == 200){
                  Navigator.pop(context);
                }
                else{
                  print(response.statusCode);
                  print(response.body);
                }

                setState(() {
                  doneButtonClicked = false;
                });
              },
              child: doneButtonClicked? CircularProgressIndicator(color: Colors.white,):Text(AppLocalizations.of(context)!.done),
            ),
          ),
        )
    );
  }
}
