import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/classes/MedicineCategoryInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../BackEndURL.dart';
import 'package:vibration/vibration.dart';



class MedicineCategories extends StatefulWidget {
  const MedicineCategories({Key? key}) : super(key: key);

  @override
  _MedicineCategoriesState createState() => _MedicineCategoriesState();
}

class _MedicineCategoriesState extends State<MedicineCategories> {

  List<MedicineCategoryInfo> allCategories = List.empty(growable: true);
  bool dataIsFetched = false;

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    allCategories.clear();
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
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200){
      List<dynamic> data = JsonResponse['data'];
      for (int i=0;i<data.length;i++){
        Map <String,dynamic> oneTest = data[i];
        String id = oneTest['id'].toString();
        String name = oneTest['name'].toString();
        allCategories.add(new MedicineCategoryInfo(id, name));
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
        title: Text(AppLocalizations.of(context)!.medicineCategories,style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          child: dataIsFetched == false ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: ()async{
              await getAllCategories();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  child: MyContainer(
                    Text(allCategories[index].name,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                    SizedBox(),
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
                      await Navigator.pushNamed(context, '/addmedicinecategory',arguments: {
                        'info': allCategories[index],
                      });
                      await getAllCategories();
                    }
                  },
                );
              },
            ),
          )

      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(AppLocalizations.of(context)!.addNewCategory),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addmedicinecategory');
          getAllCategories();
        },
      ),
    );
  }


}
