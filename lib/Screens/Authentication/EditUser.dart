import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/SecureStorage.dart';
import 'package:medical_app/classes/UserInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../BackEndURL.dart';
import 'dart:convert';


class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  bool valuesIsInit = false;
  late UserInfo info;
  TextEditingController usernameInput = TextEditingController(text: "");
  TextEditingController emailInput = TextEditingController(text: "");
  TextEditingController accountTypeInput = TextEditingController(text: "");
  String passwordInput = "";
  String confirmPasswordInput = "";

  bool editPassword = false;
  bool doneClicked = false;


  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    if (arguments['info'] != null && !valuesIsInit) {
      info = arguments['info'];
      usernameInput = TextEditingController(text: info.name);
      emailInput = TextEditingController(text: info.email);
      accountTypeInput = TextEditingController(text: info.role);
      valuesIsInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editAccount,style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
                AccountType(),
                Username(),
                Email(),
                PasswordAndConfirmPassword(),
                doneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget AccountType(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.accountType,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: MyGreyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none
                ),
                fillColor: MyGreyColor,
                prefixIcon: Icon(null),
                filled: false,
                hintText: AppLocalizations.of(context)!.accountType,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              isExpanded: true,
              value: accountTypeInput.text=="" ? null: accountTypeInput.text,
              items: ['Patient','Doctor','Admin', 'Ads'].map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (selectedValue){
                setState(() {
                  accountTypeInput.text = selectedValue.toString();
                });
              },
              dropdownColor: Colors.white,
            ),
          ),
        );
  }

  Widget Username(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.name,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: usernameInput,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterBloodTestName,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: usernameInput.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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
            )
        )
    );
  }

  Widget Email(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.email,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        SizedBox(
            width: 250,
            child: TextField(
              controller: emailInput,
              cursorColor: Colors.black,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterBloodTestName,
                hintStyle: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: emailInput.text ==""? BorderSide(color: Colors.blueAccent,): BorderSide.none,
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
            )
        )
    );
  }

  Widget Password(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.password,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        MyTextField(
          AppLocalizations.of(context)!.password,
          Icon(CupertinoIcons.lock, color: Colors.grey),
          true,
          (newVal) => {
            setState(() {
            passwordInput = newVal;
            })
          }
        )
    );
  }

  Widget ConfirmPassword(){
    return MyContainer(
        Text(AppLocalizations.of(context)!.confirmPassword,style: TextStyle(fontSize: 20,color: MyGreyColorDarker),),
        MyTextField(
          AppLocalizations.of(context)!.confirmPassword,
          Icon(CupertinoIcons.lock, color: Colors.grey),
          true,
          (newVal) => {
            setState(() {
            confirmPasswordInput = newVal;
            })
          })
    );
  }

  Widget PasswordAndConfirmPassword(){
    return ExpansionTile(
        title: Text(
            AppLocalizations.of(context)!.doYouWantToEditPassword,
            style: TextStyle(color: editPassword ? Colors.green : Colors.red),
        ),
        trailing: editPassword
            ? Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: Colors.green,
        )
            : Icon(
          CupertinoIcons.clear_circled_solid,
          color: Colors.red,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            editPassword = expanded;
          });
        },
        leading: Icon(
          Icons.label,
          color: Colors.black,
        ),
        children: [
          Password(),
          ConfirmPassword()
        ]
    );
  }

  Widget doneButton(){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: doneClicked ? null : () async {
          setState(() {
            doneClicked = true;
          });

          String? token = await storage.read(key: 'token');

          var Body;
          if (editPassword) {
            Body = jsonEncode(<String, String>{
              "name": usernameInput.text,
              "email": emailInput.text,
              "role": accountTypeInput.text,
              "password": passwordInput,
              "password_confirmation": confirmPasswordInput,
            });
          }
          else{
            Body = jsonEncode(<String, String>{
              "name": usernameInput.text,
              "email": emailInput.text,
              "role": accountTypeInput.text,
            });
          }
          http.Response response = await http.put(
            Uri.parse(URL + '/api/user/manager/' + info.id),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Connection': 'keep-alive',
              'Accept-Encoding': 'gzip, deflate, br',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: Body,
          );

          if (response.statusCode ==200) {
            Navigator.pop(context);
          }
          else {
            print(response.body);
            print(response.statusCode);
          }
          setState(() {
            doneClicked = false;
          });
        },
        child: doneClicked ? CircularProgressIndicator(color: Colors.white,) : Text(AppLocalizations.of(context)!.done),
      )
    );
  }

}
