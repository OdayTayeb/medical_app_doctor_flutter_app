import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:medical_app/globalWidgets.dart';
import 'package:flutter/cupertino.dart';
import '../../SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../DeviceName.dart';
import '../../BackEndURL.dart';



class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // This is The content of the Text fields
  String emailInput="";
  String passwordInput="";

  // This is the message shown after failing to sign In
  String message="";

  // This is true when signIn button is clicked
  bool signInClicked = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                    children: [
                      logoImage(),
                      LoginToYourAccountText(),
                      EmailAndPassword(),
                      signInButton(),
                      messageText(),
                      forgetPasswordButton(),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
        )
    );
  }

  Widget logoImage(){
    double H = MediaQuery.of(context).size.height / 4;
    double W = MediaQuery.of(context).size.width;
    return Container(
      width: W,
      height: H,
      child: FittedBox(child: Image.asset('images/logo.png'),fit: BoxFit.contain,)
    );
  }

  Widget LoginToYourAccountText(){
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.loginToYourAccount,
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget EmailAndPassword(){
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Email(),
          Password(),
        ],
      ),
    );
  }

  Widget Email(){
    return MyTextField(
        AppLocalizations.of(context)!.email,
        Icon(CupertinoIcons.envelope,color: Colors.grey),
        false,
            (newVal)=>{  setState((){ emailInput = newVal;}) }
    );
  }

  Widget Password(){
    return MyTextField(
        AppLocalizations.of(context)!.password,
        Icon(CupertinoIcons.lock,color: Colors.grey),
        true,
        (newVal)=>{  setState((){ passwordInput = newVal;}) }
    );
  }

  Widget signInButton(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: signInClicked ? null : () async {

          setState(() {
            signInClicked = true;

            // Front End Validation

            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailInput))
              message = AppLocalizations.of(context)!.invalidEmail;
            else if (passwordInput.length < 8)
              message = AppLocalizations.of(context)!.shortPassword;
            else
              message = "";

          });

          if (message=="") {
            try {

              String deviceName = await DeviceName();
              http.Response response = await http.post(
                Uri.parse(URL+'/api/auth/login'),
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Accept': '*/*',
                  'Connection': 'keep-alive',
                  'Accept-Encoding': 'gzip, deflate, br',
                  'Accept': 'application/json',

                },
                body: jsonEncode(<String, String>{
                  "email": emailInput,
                  "password": passwordInput,
                  "device_name": deviceName,
                }),
              );
              Map JsonResponse = jsonDecode(response.body);
              if (response.statusCode == 200) {
                await storage.write(key: 'token', value: JsonResponse['token']);
                Navigator.pushNamed(context, '/consultations');
              }
              else {
                Map<String, dynamic> errors = JsonResponse['errors'];
                setState(() {
                  message = errors[ errors.keys.toList()[0] ].toString();
                });
              }
            }
            catch(e){
              print(e);
              setState(() {
                message = "Error connecting to server";
              });
            }
          }
          setState(() {
            signInClicked = false;
          });
        },
        child: signInClicked? CircularProgressIndicator(color: Colors.white,): Text(AppLocalizations.of(context)!.signIn),
      ),
    );
  }

  Widget messageText(){
    return Text(message,style: TextStyle(color: Colors.red),);
  }

  Widget forgetPasswordButton(){
    return TextButton(
        onPressed: ()=>{},
        child: Text(AppLocalizations.of(context)!.forgotPassword,
        ));
  }

  Widget dontHaveAnAccountText(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.dontHaveAccount,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15.0,
          ),
        ),
        TextButton(onPressed: ()=>{Navigator.pop(context)}, child: Text(AppLocalizations.of(context)!.signUp,style: TextStyle(fontSize: 16),)),
      ],
    );
  }
}


