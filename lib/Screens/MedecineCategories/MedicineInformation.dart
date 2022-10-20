import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/classes/RadioGraphTestInfo.dart';
import 'package:medical_app/globalWidgets.dart';


class MedicineInformation extends StatelessWidget {
  const MedicineInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    MedicineInfo info = arguments['info'];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(info.genericName,style: TextStyle(color: Colors.white,fontSize: 32,fontWeight: FontWeight.bold),),
                  Text(info.tradeName,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)
                ],
              )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyContainer(
                      Text(AppLocalizations.of(context)!.category,style: TextStyle(fontSize: 20,color: MyGreyColorDarker)),
                      Text(info.category,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,))
                  ),
                  Expanded(
                    child: MyContainer(
                        Text(AppLocalizations.of(context)!.note,style: TextStyle(fontSize: 20,color: MyGreyColorDarker)),
                        Text(info.note,style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold,)),
                    ),
                  ),
                ],
              )
            ),
            ],
        ),
      ),
    );
  }
}
