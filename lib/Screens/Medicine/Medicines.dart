import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/MedicineCategoryInfo.dart';
import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../BackEndURL.dart';
import 'package:vibration/vibration.dart';



class Medicines extends StatefulWidget {
  const Medicines({Key? key}) : super(key: key);

  @override
  _MedicinesState createState() => _MedicinesState();
}

class _MedicinesState extends State<Medicines> {

  List<MedicineInfo> allMedicines = List.empty(growable: true);
  bool dataIsFetched = false;

  @override
  void initState() {
    super.initState();
    getAllMedicines();
  }

  Future<void> getAllMedicines() async {
    allMedicines.clear();
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
        allMedicines.add(new MedicineInfo(id, genericname,tradename,categoryName,categoryId,note));
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
        title: Text(AppLocalizations.of(context)!.medicines,style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          child: dataIsFetched == false ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: ()async{
              await getAllMedicines();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allMedicines.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  child: MyContainer(
                    Text(allMedicines[index].genericName,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                    Text(allMedicines[index].tradeName+" \u25CF "+allMedicines[index].category,style: TextStyle(fontSize: 16, color: MyGreyColorDarker))
                  ),
                  key: ValueKey(index),
                  background: Container(
                    color: Colors.green,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10,),
                        Text(AppLocalizations.of(context)!.edit,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.amber,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(AppLocalizations.of(context)!.details,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(width: 10,),
                        Icon(
                          CupertinoIcons.info_circle_fill,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    return false;
                  },
                  onUpdate: (details) async{
                    if (details.reached && !details.previousReached){
                      bool hasVib = await Vibration.hasVibrator() ?? false;
                      if (hasVib)
                        Vibration.vibrate(duration: 100);
                      if (details.direction == DismissDirection.startToEnd) {
                        await Navigator.pushNamed(
                            context, '/addmedicine', arguments: {
                          'info': allMedicines[index],
                        });
                      }
                      else {
                        await Navigator.pushNamed(
                            context, '/medicineinfo', arguments: {
                          'info': allMedicines[index],
                        });
                      }
                      await getAllMedicines();
                    }
                  },
                );
              },
            ),
          )

      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(AppLocalizations.of(context)!.newMedicine),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addmedicine');
          getAllMedicines();
        },
      ),
    );
  }


}
