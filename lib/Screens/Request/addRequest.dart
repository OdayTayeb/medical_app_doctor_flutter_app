import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/BloodTestInfo.dart';
import 'package:medical_app/classes/RadioGraphTestInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'package:http/http.dart' as http;
import '../../BackEndURL.dart';
import 'dart:convert';


class addRequest extends StatefulWidget {
  const addRequest({Key? key}) : super(key: key);

  @override
  _addRequestState createState() => _addRequestState();
}

class _addRequestState extends State<addRequest> {

  String consultationId= "";
  String type = "Normal";
  TextEditingController requestInput = TextEditingController(text: "");
  bool doneButtonClicked = false;
  List<BloodTestInfo> allBloodTests = List.empty(growable: true);
  bool bloodTestsFetched = false;
  List<RadioGraphTestInfo> allRadioGraphTests = List.empty(growable: true);
  bool RadioGraphFetched = false;
  List <String> selectedBloodTests = List.empty(growable: true);
  List <String> selectedRadioGraphs = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    getAllRadioGraphTests();
    getAllBloodTests();
  }

  Future<void> getAllRadioGraphTests() async {
    allRadioGraphTests.clear();
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/radiograph'),
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
        String comment = oneTest['comment'].toString();
        allRadioGraphTests.add(new RadioGraphTestInfo(id, name, comment));
      }
    }
    setState(() {
      RadioGraphFetched = true;
    });
  }

  Future<void> getAllBloodTests() async {
    allBloodTests.clear();
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/bloodtest'),
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
        String comment = oneTest['comment'].toString();
        allBloodTests.add(new BloodTestInfo(id, name, comment));
      }
    }
    setState(() {
      bloodTestsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    consultationId = arguments['id'];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.requestInformation,style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RequestType(),
            RequestContent(),
            if (type == "BloodTest" && !bloodTestsFetched)
              CircularProgressIndicator(),
            if (type == "BloodTest" && bloodTestsFetched)
              SelectWantedBloodTestsText(),
            if (type == "BloodTest" && bloodTestsFetched)
              BloodTests(),
            if (type == "Radiograph" && !RadioGraphFetched)
              CircularProgressIndicator(),
            if (type == "Radiograph" && RadioGraphFetched)
              SelectWantedRadioGraphText(),
            if (type == "Radiograph" && RadioGraphFetched)
              RadioGraphs(),
          ],
        ),
      ),
      bottomNavigationBar: DoneButton()
    );
  }

  Widget RequestType(){
    return MyContainer(
      Text(AppLocalizations.of(context)!.requestType,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
      Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
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
          value: type=="" ? null: type,
          items: ['BloodTest', 'Normal', 'Radiograph'].map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (selectedValue){
            setState(() {
              type = selectedValue.toString();
            });
          },
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget RequestContent(){
    return MyContainer.anotherConstructor(
      Text(AppLocalizations.of(context)!.requestContent,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
      SizedBox(
        width: 250,
        height: MediaQuery.of(context).size.height/8,
        child: Center(
          child: TextField(
            controller: requestInput,
            cursorColor: Colors.black,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterYour+AppLocalizations.of(context)!.requestContent,
              hintStyle: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: requestInput.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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
      MediaQuery.of(context).size.height/4,
      MediaQuery.of(context).size.width,
    );
  }

  Widget SelectWantedBloodTestsText(){
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.chooseRequiredBloodTests,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget BloodTests(){
    List<Widget> choices = List.empty(growable: true);
    for (int i=0;i<allBloodTests.length;i++)
      choices.add( Container(
        padding: const EdgeInsets.all(3.0),
        child: ChoiceChip(
          selectedColor: Colors.green,
          label: Text(allBloodTests[i].name,style: TextStyle(fontSize: 16),),
          selected: selectedBloodTests.contains(allBloodTests[i].id),
          onSelected: (selected) {
            setState(() {
              selectedBloodTests.contains(allBloodTests[i].id)
                  ? selectedBloodTests.remove(allBloodTests[i].id)
                  : selectedBloodTests.add(allBloodTests[i].id);
            });
          },
        ),
      ));
    return Wrap(
      children: choices,
    );
  }

  Widget SelectWantedRadioGraphText(){
    return Container(
      height: MediaQuery.of(context).size.height / 10,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.chooseRequiredRadioGraphTests,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget RadioGraphs(){
    List<Widget> choices = List.empty(growable: true);
    for (int i=0;i<allRadioGraphTests.length;i++)
      choices.add( Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          selectedColor: Colors.green,
          label: Text(allRadioGraphTests[i].name),
          selected: selectedRadioGraphs.contains(allRadioGraphTests[i].id),
          onSelected: (selected) {
            setState(() {
              selectedRadioGraphs.contains(allRadioGraphTests[i].id)
                  ? selectedRadioGraphs.remove(allRadioGraphTests[i].id)
                  : selectedRadioGraphs.add(allRadioGraphTests[i].id);
            });
          },
        ),
      ));
    return Wrap(
      children: choices,
    );
  }

  List <String> getSelectedBloodTestsNames(){
    List <String> names = List.empty(growable: true);
    for (int i=0;i<allBloodTests.length;i++)
      if (selectedBloodTests.contains(allBloodTests[i].id))
        names.add(allBloodTests[i].name);
    return names;
  }

  List <String> getSelectedRadioGraphNames(){
    List <String> names = List.empty(growable: true);
    for (int i=0;i<allRadioGraphTests.length;i++)
      if (selectedRadioGraphs.contains(allRadioGraphTests[i].id))
        names.add(allRadioGraphTests[i].name);
    return names;
  }

  Widget DoneButton(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: doneButtonClicked? null: () async {
          setState(() {
            doneButtonClicked = true;
          });

          Map Body = {
            'type' : type,
            'comment': requestInput.text,
          };
          if (type == 'BloodTest')
            Body['BloodTestIdArray'] = selectedBloodTests;
          else if (type == 'Radiograph')
            Body['RadiographIdArray'] = selectedRadioGraphs;

          String? token = await storage.read(key: 'token');
          http.Response response = await http.post(
            Uri.parse( URL+ '/api/' + consultationId + '/req'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(Body),
          );
          Map JsonResponse = jsonDecode(response.body);
          if (response.statusCode == 201){
            if (type == "BloodTest"){
              List<String> tests= getSelectedBloodTestsNames();
              Map x = {
                'content' : requestInput.text,
                'tests' : tests
              };
              Navigator.pop(context, x);
            }
            else if (type == 'Radiograph'){
              List<String> tests= getSelectedRadioGraphNames();
              Map x = {
                'content' : requestInput.text,
                'tests' : tests
              };
              Navigator.pop(context,x);
            }
            else
              Navigator.pop(context,requestInput.text);
          }
          else{
            print(response.statusCode);
            print(JsonResponse);
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
