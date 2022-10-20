import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/MedicineCategoryInfo.dart';
import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import 'package:http/http.dart' as http;
import '../../SecureStorage.dart';
import '../../BackEndURL.dart';
import 'dart:convert';

class addMedicine extends StatefulWidget {
  const addMedicine({Key? key}) : super(key: key);

  @override
  State<addMedicine> createState() => _addMedicineState();
}

class _addMedicineState extends State<addMedicine> {

  TextEditingController genericNameController = TextEditingController(text: "");
  TextEditingController tradeNameController = TextEditingController(text: "");
  TextEditingController noteController = TextEditingController(text: "");
  String category = "";
  bool doneButtonClicked = false;

  List <MedicineCategoryInfo> Categories = List.empty(growable: true);

  bool valuesIsInit = false;
  bool dataIsFetched = false;
  late MedicineInfo info;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    Categories.clear();
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
        Map <String,dynamic> oneTest = data[i];
        String id = oneTest['id'].toString();
        String name = oneTest['name'].toString();
        Categories.add(new MedicineCategoryInfo(id, name));
      }
    }
    setState(() {
      dataIsFetched = true;
    });
  }


  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['info'] != null && !valuesIsInit) {
      info = arguments['info'];
      genericNameController = TextEditingController(text: info.genericName);
      tradeNameController = TextEditingController(text: info.tradeName);
      noteController = TextEditingController(text: info.note);
      category = info.categoryId;
      valuesIsInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.medicineInformation,style: TextStyle(color: Colors.black),),
      ),
      body: dataIsFetched == false ?
      Center(
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Column(
          children: [
            GenericName(),
            TradeName(),
            Category(),
            Note(),
            addNewMedicineButton(),
          ],
        ),
      ),
    );
  }

  Widget GenericName(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.name,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: genericNameController,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter+ " "+AppLocalizations.of(context)!.medicineName,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: genericNameController.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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

  Widget TradeName(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.commercialName,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: tradeNameController,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter+ " "+AppLocalizations.of(context)!.commercialName,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: tradeNameController.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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

  Widget Category(){
    return MyContainer(
      Text(AppLocalizations.of(context)!.category,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
      Container(
        width: MediaQuery.of(context).size.width / 1.5,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              prefixIcon: Icon(null),
              hintText: AppLocalizations.of(context)!.choose+" "+AppLocalizations.of(context)!.category,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            isExpanded: true,
            value: category=="" ? null: category,
            items: Categories.map((MedicineCategoryInfo items) {
              return DropdownMenuItem(
                value: items.id,
                child: Text(items.name,overflow: TextOverflow.ellipsis,),
              );
            }).toList(),
            onChanged: (selectedValue){
              setState(() {
                category = selectedValue.toString();
                print(category);
              });
            },
            dropdownColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget Note(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.note,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: noteController,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enter+" " +AppLocalizations.of(context)!.note,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: noteController.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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


  Widget addNewMedicineButton(){
    return Padding(
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
              Uri.parse(URL + '/api/drug'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, String>{
                "genericName": genericNameController.text,
                "tradeName": tradeNameController.text,
                "category_id": category,
                "note": noteController.text,
              }),
            );
          }
          else{
            response = await http.put(
              Uri.parse(URL + '/api/drug/' + info.id),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Connection': 'keep-alive',
                'Accept-Encoding': 'gzip, deflate, br',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode(<String, String>{
                "genericName": genericNameController.text,
                "tradeName": tradeNameController.text,
                "category_id": category,
                "note": noteController.text,
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
    );
  }
}
