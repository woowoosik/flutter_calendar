import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



typedef Callback = void Function();

class TextFieldWidget extends StatelessWidget{

  String hint;
  Widget icon;
  dynamic controller;

  bool password;

  Callback callback;

  TextFieldWidget({
    super.key,
    required this.password,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe6dfd8), Color(0xFFf7f5ec)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      child: TextField(
        controller: controller,
        expands: false,
        style: const TextStyle(fontSize: 17.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: icon,
          hintText: hint ,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black26),
        ),
        obscureText: password? true : false,
        keyboardType: TextInputType.text,
        onSubmitted: (value){
          callback.call();
        },
      ),
    );
  }
}
