import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/Screens/Authentication/EditUser.dart';
import 'package:medical_app/Screens/Authentication/userManager.dart';
import 'package:medical_app/Screens/Consultations/ConsulatationInformation.dart';
import 'package:medical_app/Screens/Consultations/Consultations.dart';
import 'package:medical_app/Screens/Diagnosis/CreateDiagnosis.dart';
import 'Screens/Diagnosis/DiagnosisMedicinesManagement.dart';
import 'package:medical_app/Screens/MedecineCategories/MedicineCategories.dart';
import 'package:medical_app/Screens/MedecineCategories/MedicineInformation.dart';
import 'package:medical_app/Screens/MedecineCategories/addMedicineCategory.dart';
import 'package:medical_app/Screens/Medicine/Medicines.dart';
import 'package:medical_app/Screens/Medicine/addMedicine.dart';
import 'package:medical_app/Screens/MedincineOptions/MedicineOptionInformation.dart';
import 'package:medical_app/Screens/MedincineOptions/MedicineOptions.dart';
import 'package:medical_app/Screens/MedincineOptions/addMedicineOption.dart';
import 'package:medical_app/Screens/RadioGraphTests/RadioGraphTestInformation.dart';
import 'package:medical_app/Screens/RadioGraphTests/RadiographTests.dart';
import 'package:medical_app/Screens/RadioGraphTests/addRadiographTest.dart';
import 'package:medical_app/Screens/Request/addRequest.dart';
import 'package:medical_app/Screens/bloodTests/BloodTestInformation.dart';
import 'package:medical_app/Screens/bloodTests/BloodTests.dart';
import 'package:medical_app/Screens/bloodTests/addBloodTest.dart';
import 'package:medical_app/Screens/home/HomePage.dart';
import 'package:medical_app/Screens/tools/ImageShow.dart';
import 'package:medical_app/Screens/tools/PdfView.dart';
import 'package:medical_app/classes/MedicineInfo.dart';
import 'package:medical_app/classes/MedicineOptionsInfo.dart';
import 'Screens/Authentication/SignUp.dart';
import 'Screens/Authentication/SignIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context)  {

    return MaterialApp(
      // For Internationalization (Arabic and English)
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: Locale('ar',''),
      // routing
      routes: {
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUp(),
        '/signin': (context) => SignIn(),
        '/bloodtests': (context) => BloodTests(),
        '/addbloodtest' : (context) => addBloodTest(),
        '/bloodtestinfo': (context) => BloodTestInformation(),
        '/radiographtests': (context) => RadioGraphTests(),
        '/addradiographtest' : (context) => addRadioGraphTest(),
        '/radiographtestinfo': (context) => RadioGraphTestInformation(),
        '/usermanager': (context) => UserManager(),
        '/edituser': (context) =>EditUser(),
        '/medicinecategories': (context) => MedicineCategories(),
        '/addmedicinecategory': (context) => addMedicineCategory(),
        '/medicines': (context) => Medicines(),
        '/addmedicine': (context) => addMedicine(),
        '/medicineinfo': (context) => MedicineInformation(),
        '/medicineoptions': (context) => MedicineOptions(),
        '/addmedicineoption': (context) => addMedicineOption(),
        '/medicineoptioninfo': (context) => MedicineOptionInformation(),
        '/consultations' : (context) => Consultations(),
        '/consultationinformation': (context) => ConsultationInformation(),
        '/imageshow': (context) =>ImageShow(),
        '/pdfview': (context) =>PdfView(),
        '/addrequest': (context) => addRequest(),
        '/creatediagnosis': (context) =>CreateDiagnosis(),
        '/diagnosismedicinesmanagement': (context) => DiagnosisMedicinesManagement(),
      },
      initialRoute: '/signin',
      // Theme
      theme: ThemeData.light().copyWith(
        backgroundColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                )
            ),
            minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)),
          )
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(headline6: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500)),
          elevation: 0,
        )
      ),
    );
  }
}


