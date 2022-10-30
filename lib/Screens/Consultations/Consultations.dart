import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medical_app/classes/ConsultationInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import '../../SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../classes/PatientInfoClass.dart';
import '../../BackEndURL.dart';
import 'package:vibration/vibration.dart';
import 'dart:ui' as ui;



class Consultations extends StatefulWidget {
  const Consultations({Key? key}) : super(key: key);

  @override
  _ConsultationsState createState() => _ConsultationsState();
}

class _ConsultationsState extends State<Consultations> {

  List<ConsultationInfo> allConsultations = List.empty(growable: true);
  bool dataIsFetched = false;

  @override
  void initState() {
    super.initState();

    getAllConsultations();
  }

  Future<void> getAllConsultations() async {
    allConsultations.clear();
    String? token = await storage.read(key: 'token');
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/consultation'),
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
        String start_at = x['start_at'].toString();
        String end_at = x['end_at'].toString();
        String patient_complaint = x['patient_complaint'].toString();
        Map <String,dynamic> status = x['status'];
        String status_name = status['name'];
        Map <String,dynamic> patient = x['patient'];
        String patient_name = patient['name'];
        String patient_phone = patient['phone'];
        String patient_address = patient['address'];
        Map <String,dynamic> user = x['user'];
        String user_email = user['email'].toString();
        allConsultations.add(new ConsultationInfo(id, start_at, end_at,patient_complaint,status_name,patient_name,patient_phone,patient_address,user_email));
      }
    }
    setState(() {
      dataIsFetched = true;
    });
  }


  bool isRTL(String text) {
    return Bidi.detectRtlDirectionality(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allConsultations,style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          child: dataIsFetched == false ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: ()async{
              await getAllConsultations();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allConsultations.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/consultationinformation', arguments: {
                      'id': allConsultations[index].id,
                    });
                  },
                  child: Dismissible(
                    child: Card(
                        margin: EdgeInsets.all(10),
                        shadowColor: Colors.blue,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.black87, Colors.blue],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          ),
                          child: Column(
                              children : [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Text(AppLocalizations.of(context)!.consultation+" ("+allConsultations[index].id+")",style: TextStyle(color: Colors.amber,fontWeight: FontWeight.w900,fontSize: 30),),
                                ),
                                /*Text(
                                  AppLocalizations.of(context)!.consultationDate+allConsultations[index].start_at,
                                  style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                                ),*/
                                MyDivider(AppLocalizations.of(context)!.pateintInformation, Colors.amber),
                                Text(
                                    AppLocalizations.of(context)!.patientName+allConsultations[index].patient_name+"\n"+
                                    AppLocalizations.of(context)!.patientPhone+allConsultations[index].patient_phone+"\n"+
                                    AppLocalizations.of(context)!.patientAddress+allConsultations[index].patient_address+"\n"+
                                    AppLocalizations.of(context)!.userEmail+allConsultations[index].user_email,
                                    style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                                ),
                                MyDivider(AppLocalizations.of(context)!.patientComplaint, Colors.amber),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                                    child: Text(
                                      allConsultations[index].patient_complaint,
                                      maxLines: 5,
                                      textDirection: isRTL(allConsultations[index].patient_complaint) ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                                      style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                                    )
                                ),
                                MyDivider(AppLocalizations.of(context)!.consultationStatus, Colors.amber),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child:Text(allConsultations[index].status_name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)
                                ),
                              ]
                          ),
                        )
                    ),
                    key: ValueKey(index),
                    direction: DismissDirection.none,
                    background: Container(
                      color: Colors.amber,
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
                    confirmDismiss: (direction) async {
                      return false;
                    },
                    onUpdate: (details) async{
                      if (details.reached && !details.previousReached){
                        bool hasVib = await Vibration.hasVibrator() ?? false;
                        if (hasVib)
                          Vibration.vibrate(duration: 100);
                        if (details.direction == DismissDirection.startToEnd){

                        }
                        else {

                        }
                      }
                    },
                  ),
                );
              },
            ),
          )

      ),
    );
  }


}
