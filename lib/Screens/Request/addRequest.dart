import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/BloodTestInfo.dart';
import 'package:medical_app/classes/RadioGraphTestInfo.dart';
import 'package:medical_app/classes/RequestInfo.dart';
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

  int index = 0;
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
  bool valuesInitialized = false;
  late RequestInfo requestInfo;

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
      for (int i=0;i<selectedRadioGraphs.length;i++)
        for (int j=0;j<allRadioGraphTests.length;j++)
          if (selectedRadioGraphs[i] == allRadioGraphTests[j].name){
            selectedRadioGraphs[i] = allRadioGraphTests[j].id;
            break;
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
      for (int i=0;i<selectedBloodTests.length;i++)
        for (int j=0;j<allBloodTests.length;j++)
          if (selectedBloodTests[i] == allBloodTests[j].name){
            selectedBloodTests[i] = allBloodTests[j].id;
            break;
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
    index = arguments['index'];
    if (arguments['Request']!=null && !valuesInitialized){
      requestInfo = arguments['Request'];
      if (requestInfo.bloodTests.length>0) {
        type = "BloodTest";
        selectedBloodTests.addAll(requestInfo.bloodTests);
      }
      else if (requestInfo.radioTests.length>0) {
        type = "Radiograph";
        selectedRadioGraphs.addAll(requestInfo.radioTests);
      }
      requestInput = TextEditingController(text: requestInfo.comment);
      valuesInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.requestInformation,style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!valuesInitialized)
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

          http.Response response;
          if (!valuesInitialized) {
            response = await http.post(
              Uri.parse(URL + '/api/' + consultationId + '/req'),
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
          }
          else{
             response = await http.put(
              Uri.parse(URL + '/api/' + consultationId + '/req/'+requestInfo.id),
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
          }

          if (response.statusCode == 201 || response.statusCode == 200){
            Map JsonResponse = jsonDecode(response.body);
            Map item = JsonResponse['data'];
            // Map x = item;
            // print(x.keys.length);
            // for (int i=0;i<x.keys.length;i++)
            //   print(x.keys.elementAt(i).toString()+" "+x[x.keys.elementAt(i)].toString());
            String id = item['id'].toString();
            String comment = item['comment'];
            List <String> bloodTests = List.empty(growable: true);
            List <dynamic> bt = item['bloodTests'];
            for (int j = 0; j < bt.length; j++)
              bloodTests.add(bt[j]['name'].toString());
            List <String> radioTests = List.empty(growable: true);
            List <dynamic> rt = item['radiographs'];
            for (int j = 0; j < rt.length; j++)
              radioTests.add(rt[j]['name'].toString());
            RequestInfo R;
            if (!valuesInitialized)
              R = RequestInfo(id, index, comment, bloodTests, radioTests, false);
            else {
              requestInfo.comment = comment;
              requestInfo.bloodTests = bloodTests;
              requestInfo.radioTests = radioTests;
              R = requestInfo;
            }
            Navigator.pop(context,R);
          }
          else{
            print(jsonEncode(Body));
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
