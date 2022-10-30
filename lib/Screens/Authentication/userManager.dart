import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/classes/UserInfo.dart';
import '../../SecureStorage.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../BackEndURL.dart';
import 'package:vibration/vibration.dart';



class UserManager extends StatefulWidget {
  const UserManager({Key? key}) : super(key: key);

  @override
  _UserManagerState createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager> {

  List<UserInfo> allUsers = List.empty(growable: true);
  bool dataIsFetched = false;

  var roleColors = {
    'Patient' : Colors.green,
    'Admin' : Colors.red,
    'Ads': Colors.yellow,
    'Doctor' : Colors.orange,
  };

  @override
  void initState() {
    super.initState();
    getAllUsers();
  }

  Future<void> getAllUsers() async {
    allUsers.clear();
    String? token = await storage.read(key: 'token');
    print(token);
    http.Response response = await http.get(
      Uri.parse( URL+ '/api/user/manager'),
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
        String name = x['name'].toString();
        String email = x['email'].toString();
        String role = x['role'].toString();
        allUsers.add(new UserInfo(id, name, email,role));
      }
    }
    setState(() {
      dataIsFetched = true;
    });
  }

  showAlertDialog(BuildContext context,int index) {
    Widget cancelButton = TextButton(
      child: Text(AppLocalizations.of(context)!.no),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppLocalizations.of(context)!.yes),
      onPressed:  () async {
        String? token = await storage.read(key: 'token');
        http.Response response = await http.delete(
          Uri.parse( URL+'/api/user/manager/'+allUsers[index].id),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': '*/*',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 204){
          setState(() {
            allUsers.removeAt(index);
          });
        }
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(AppLocalizations.of(context)!.delete),
      content: Text(AppLocalizations.of(context)!.areYouSureYouWantTo+AppLocalizations.of(context)!.delete+" "+allUsers[index].name+"?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userAccountManager,style: TextStyle(color: Colors.black),),
      ),
      body: Container(
          child: dataIsFetched == false ?
          Center(
            child: CircularProgressIndicator(),
          ) :
          RefreshIndicator(
            onRefresh: ()async{
              await getAllUsers();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  child: Card(
                    child: ListTile(
                      title: Text(allUsers[index].name,style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(allUsers[index].email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,size: 8,color: roleColors[allUsers[index].role],),
                          SizedBox(width: 5,),
                          Text(allUsers[index].role)
                        ],
                      ),
                    ),
                  ),
                  key: ValueKey(index),
                  background: Container(
                    color: Colors.blue,
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
                  direction: DismissDirection.horizontal,
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
                      if (details.direction == DismissDirection.startToEnd) {
                        await Navigator.pushNamed(
                            context, '/edituser', arguments: {
                          'info': allUsers[index],
                        });
                      }
                      else {
                        showAlertDialog(context, index);
                      }
                      await getAllUsers();
                    }
                  },
                );
              },
            ),
          )

      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(AppLocalizations.of(context)!.createNewAccount),
        onPressed: () async {
          await Navigator.pushNamed(context, '/signup');
          getAllUsers();
        },
      ),
    );
  }


}
