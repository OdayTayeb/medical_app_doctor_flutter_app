import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'MyColors.dart';
import 'package:flutter/cupertino.dart';

typedef onChangeFunction = void Function(String);

class MyTextField extends StatefulWidget {
  String Wantedtext;
  Icon Wantedicon;
  bool secureText;
  onChangeFunction onChangeCallback;

  MyTextField(
      this.Wantedtext, this.Wantedicon, this.secureText, this.onChangeCallback);

  @override
  _MyTextFieldState createState() => _MyTextFieldState(secureText);
}

class _MyTextFieldState extends State<MyTextField> {
  bool secureText;

  _MyTextFieldState(this.secureText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: TextField(
        style: TextStyle(
          fontSize: 14
        ),
        obscureText: secureText,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          enabledBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(20.0),
            borderSide: BorderSide(color: MyGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          filled: true,
          fillColor: MyGreyColor,
          hintText: widget.Wantedtext,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: widget.Wantedicon,
          suffixIcon: widget.secureText
              ? IconButton(
                  icon: Icon(
                      secureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      secureText = !secureText;
                    });
                  },
                )
              : null,
        ),
        onChanged: widget.onChangeCallback,
      ),
    );
  }
}

class MyContainer extends StatelessWidget {

  Widget w1,w2;
  double? Height = 0;
  double? Width = 0;

  MyContainer(this.w1,this.w2);
  MyContainer.anotherConstructor(this.w1,this.w2,this.Height,this.Width);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: Height==0? MediaQuery.of(context).size.height / 6 : Height,
      width: Width ==0? MediaQuery.of(context).size.width : Width,
      decoration: BoxDecoration(
        border: Border.all(color: MyGreyColorDarker, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          w1,
          w2,
        ],
      ),
    );
  }
}

class MyDivider extends StatelessWidget {

  String text = "";
  Color color;

  MyDivider(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: Row(
          children: [
            Expanded(child: Divider(color: color,endIndent: 15,indent: 10)),
            Text(
              text,
              style: TextStyle(fontSize: 17,color: color,fontWeight: FontWeight.w800),overflow: TextOverflow.ellipsis,
            ),
            Expanded(child: Divider(color: color,endIndent: 10,indent: 15,)),
          ],
        )
    );
  }
}
