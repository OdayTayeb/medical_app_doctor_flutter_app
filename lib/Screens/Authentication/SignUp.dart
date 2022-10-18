import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/MyColors.dart';
import 'package:medical_app/classes/UserInfo.dart';
import 'package:medical_app/globalWidgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../SecureStorage.dart';
import '../../DeviceName.dart';
import '../../BackEndURL.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // This is The content of the Text fields
  String emailInput = "";
  String passwordInput = "";
  String confirmPasswordInput = "";
  String usernameInput = "";
  String accountTypeInput="";

  // This is the message shown after failing to sign Up
  String message = "";

  // This is true when the sign up button is clicked
  bool signUpClicked = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
          child: Column(
            children: [
              logoImage(),
              CreateNewAccountText(),
              UserInput(),
              signUpButton(),
              messageText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget logoImage(){
    double H = MediaQuery.of(context).size.height / 5;
    double W = MediaQuery.of(context).size.width;
    return Container(
        width: W,
        height: H,
        child: FittedBox(child: Image.asset('images/logo.png'),fit: BoxFit.contain,)
    );
  }

  Widget CreateNewAccountText() {
    return Container(
        height: MediaQuery.of(context).size.height / 10,
    child: Center(
      child: Text(
        AppLocalizations.of(context)!.createNewAccount,
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          ),
        ),
      )
    );
  }

  Widget UserInput(){
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AccountType(),
          Username(),
          Email(),
          Password(),
          ConfirmPassword(),
        ],
      ),
    );
  }

  Widget AccountType(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(20.0),
                borderSide: BorderSide(color: MyGreyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              fillColor: MyGreyColor,
              prefixIcon: Icon(null),
              filled: true,
              hintText: AppLocalizations.of(context)!.accountType,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            isExpanded: true,
            value: accountTypeInput=="" ? null: accountTypeInput,
            items: ['Patient','Doctor','Admin', 'Ads'].map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (selectedValue){
              setState(() {
                accountTypeInput = selectedValue.toString();
              });
            },
            dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget Username() {
    return MyTextField(
        AppLocalizations.of(context)!.userName,
        Icon(null),
        false,
        (newVal) => {
              setState(() {
                usernameInput = newVal;
              })
            });
  }

  Widget Email() {
    return MyTextField(
        AppLocalizations.of(context)!.email,
        Icon(CupertinoIcons.envelope, color: Colors.grey),
        false,
        (newVal) => {
              setState(() {
                emailInput = newVal;
              })
            });
  }

  Widget Password() {
    return MyTextField(
        AppLocalizations.of(context)!.password,
        Icon(CupertinoIcons.lock, color: Colors.grey),
        true,
        (newVal) => {
              setState(() {
                passwordInput = newVal;
              })
            });
  }

  Widget ConfirmPassword() {
    return MyTextField(
        AppLocalizations.of(context)!.confirmPassword,
        Icon(CupertinoIcons.lock, color: Colors.grey),
        true,
        (newVal) => {
              setState(() {
                confirmPasswordInput = newVal;
              })
            });
  }

  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: signUpClicked
            ? null
            : () async {
                setState(() {
                  signUpClicked = true;

                  // Front End Validation
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailInput))
                    message = AppLocalizations.of(context)!.invalidEmail;
                  else if (passwordInput != confirmPasswordInput)
                    message = AppLocalizations.of(context)!.passwordsDoNotMatch;
                  else if (passwordInput.length < 8)
                    message = AppLocalizations.of(context)!.shortPassword;
                  else
                    message = "";
                });

                if (message == "") {
                  // Sending Request to API
                  try {
                    String? token = await storage.read(key: 'token');
                    String deviceName = await DeviceName();
                    http.Response response = await http.post(
                      Uri.parse(URL+'/api/user/manager'),
                      headers: <String, String>{
                        'Content-Type': 'application/json',
                        'Accept': '*/*',
                        'Connection': 'keep-alive',
                        'Accept-Encoding': 'gzip, deflate, br',
                        'Accept': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode(<String, String>{
                        "name": usernameInput,
                        "email": emailInput,
                        "password": passwordInput,
                        "device_name": deviceName,
                        "password_confirmation": confirmPasswordInput,
                        "role": accountTypeInput,
                      }),
                    );
                    Map JsonResponse = jsonDecode(response.body);
                    if (response.statusCode == 201) {
                      Navigator.pop(context);
                    } else {
                      Map<String, dynamic> errors = JsonResponse['errors'];
                      setState(() {
                        message = errors[errors.keys.toList()[0]].toString();
                      });
                    }
                  } catch (e) {
                    setState(() {
                      message = "Error connecting to server";
                    });
                  }
                }
                setState(() {
                  signUpClicked = false;
                });
              },
        child: signUpClicked
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(AppLocalizations.of(context)!.signUp),
      ),
    );
  }

  Widget messageText() {
    return Text(
      message,
      style: TextStyle(color: Colors.red),
    );
  }

  Widget HorizontalDevider() {
    return Row(children: <Widget>[
      Expanded(
          child: Divider(
        thickness: 2,
      )),
      Text(
        "       or continue with       ",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
          child: Divider(
        thickness: 2,
      )),
    ]);
  }

  Widget FacebookAndGoogleSignUp() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
        onPressed: () => {},
        child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(40, 40)),
            child: Image.asset('images/Google.png')),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(60, 60)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.black12),
        ),
      ),
      SizedBox(
        width: 50,
      ),
      ElevatedButton(
        onPressed: () => {},
        child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(40, 40)),
            child: Image.asset('images/Facebook.png')),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(60, 60)),
          backgroundColor: MaterialStateProperty.all(Colors.white),
          overlayColor: MaterialStateProperty.all(Colors.black12),
        ),
      ),
    ]);
  }

  Widget AlreadyHaveAcountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.haveAccountAlready,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
        TextButton(
            onPressed: () => {Navigator.pushNamed(context, '/signin')},
            child: Text(
              AppLocalizations.of(context)!.signIn,
              style: TextStyle(fontSize: 16),
            )),
      ],
    );
  }
}