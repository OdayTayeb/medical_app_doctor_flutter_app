import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/classes/RadioGraphTestInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../BackEndURL.dart';
import 'package:vibration/vibration.dart';



class RadioGraphTests extends StatefulWidget {
  const RadioGraphTests({Key? key}) : super(key: key);

  @override
  _RadioGraphTestsState createState() => _RadioGraphTestsState();
}

class _RadioGraphTestsState extends State<RadioGraphTests> {

  List<RadioGraphTestInfo> allRadioGraphTests = List.empty(growable: true);
  bool dataIsFetched = false;

  @override
  void initState() {
    super.initState();
    getAllRadioGraphTests();
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
      dataIsFetched = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.radioGraphTests,style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          child: dataIsFetched == false ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: ()async{
              await getAllRadioGraphTests();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allRadioGraphTests.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    child: MyContainer(
                        Text(allRadioGraphTests[index].name,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                        SizedBox(),
                    ),
                    key: ValueKey(index),
                    background: Container(
                      color: Colors.amber,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10,),
                          Text(AppLocalizations.of(context)!.details,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(AppLocalizations.of(context)!.delete,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (direction) async {
                      return false;
                    },
                    onUpdate: (details) async{
                      if (details.reached && !details.previousReached){
                        bool hasVib = await Vibration.hasVibrator() ?? false;
                        if (hasVib)
                          Vibration.vibrate(duration: 100);
                        await Navigator.pushNamed(context, '/radiographtestinfo',arguments: {
                          'info': allRadioGraphTests[index],
                        });
                        await getAllRadioGraphTests();
                      }
                    },
                );
              },
            ),
          )

      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(AppLocalizations.of(context)!.newRadioGraphTest),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addradiographtest');
          getAllRadioGraphTests();
        },
      ),
    );
  }


}
