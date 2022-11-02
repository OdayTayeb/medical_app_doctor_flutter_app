import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String username="",userrole="";
  Color blueColor = Color(0xff3B7893);

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    username = arguments['name'];
    userrole = arguments['role'];
    username = username[0].toUpperCase() + username.substring(1);
    if (userrole == "Doctor" || userrole == 'Admin')
      username = 'Dr. ' + username;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBar(),
            SizedBox(height: 40,),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Consultations(),
                AccountManager(),
                BloodTest(),
                RadioGraphs(),
                Medicines(),
                MedicinesCategories(),
                MedicinesOptions(),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget TopBar(){
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
          Container(
            height: MediaQuery.of(context).size.height/4.5,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: blueColor,width: 3)),
            ),
            child: Image.asset('images/doctor.jpg',fit: BoxFit.fill,),
          ),
          Positioned(
            bottom: -25,
            child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                  border: Border.all(color: blueColor, width: 2),
                  borderRadius: BorderRadius.circular(18),
                  color: blueColor,
                ),
                child: Center(child: FittedBox(fit: BoxFit.fitWidth, child: Text('Hello, '+ username,style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)))),
            ),
          ),
        ]
    );
  }

  Widget BloodTest(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/bloodtests');
      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: blueColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/bloodtest.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Text(
                    AppLocalizations.of(context)!.bloodTests,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                fit: BoxFit.fitWidth,
              )
            ],
          ),
      ),
    );
  }

  Widget Consultations(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/consultations');
      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: blueColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/consultation.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Text(
                    AppLocalizations.of(context)!.consultations,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                fit: BoxFit.fitWidth,
              )
            ],
          ),
      ),
    );
  }

  Widget AccountManager(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/usermanager');

      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: blueColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/management.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Text(
                    AppLocalizations.of(context)!.userAccountManager,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                fit: BoxFit.fitWidth,
              )
            ],
          ),
      ),
    );
  }

  Widget Medicines(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/medicines');

      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: blueColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/medicine.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Text(
                    AppLocalizations.of(context)!.medicines,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                fit: BoxFit.fitWidth,
              )
            ],
          ),
      ),
    );
  }

  Widget MedicinesCategories(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/medicinecategories');

      },
      child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: blueColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('images/medicinecategory.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10,5,10,5),
                  child: Text(
                    AppLocalizations.of(context)!.medicineCategories,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: blueColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                fit: BoxFit.fitWidth,
              )
            ],
          ),
      ),
    );
  }

  Widget MedicinesOptions(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/medicineoptions');

      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          border: Border.all(color: blueColor, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('images/medicineoptions.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            FittedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10,5,10,5),
                child: Text(
                  AppLocalizations.of(context)!.medicineOptions,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }

  Widget RadioGraphs(){
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/radiographtests');

      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
          border: Border.all(color: blueColor, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('images/radiograph.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            FittedBox(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10,5,10,5),
                child: Text(
                  AppLocalizations.of(context)!.radioGraphTests,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }
}
