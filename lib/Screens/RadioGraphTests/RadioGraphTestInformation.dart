import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/classes/RadioGraphTestInfo.dart';


class RadioGraphTestInformation extends StatelessWidget {
  const RadioGraphTestInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    RadioGraphTestInfo info = arguments['info'];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                color: Colors.blueAccent,
                height: MediaQuery.of(context).size.height/3,
                width: MediaQuery.of(context).size.width,
                child: Center(child: Text(info.name,style: TextStyle(color: Colors.white,fontSize: 32,fontWeight: FontWeight.bold),)),
            ),
            Expanded(
              child: Center(child:Text(info.description,style: TextStyle(color: Colors.black,fontSize: 20))),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/addradiographtest',arguments: {
                    'info': info,
                  });
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.edit,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),)
          ],
        ),
      ),
    );
  }
}
