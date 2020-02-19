import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final String validator;
  final String validators;
  final TextEditingController controller;
  final bool enableValidation;
  final suffixIcon;
  InputFieldArea(
      {this.hint,
      this.obscure,
      this.icon,
      this.validator,
      this.validators,
      this.controller,
      this.enableValidation = true,
        this.suffixIcon});
  @override
  Widget build(BuildContext context) {
    String validator = '$validators';
    return (new Container(
      // margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
          // border: new Border(
          // bottom: new BorderSide(
          // width: 0.5,
          // color: Colors.white24,
          // ),
          // ),
      ),
      child: new TextFormField(
        controller: controller,
        validator: (String value) {
          if (enableValidation == true) {
            if (value.isEmpty) {
              //JIKA VALUE KOSONG
              return '$validator  Tidak Boleh Kosong'; //MAKA PESAN DITAMPILKAN
            }
            return null;
          } else {
            return null;
          }
        },
        onSaved: (String value) {
          validator = value;
        },
        cursorColor: Colors.deepOrangeAccent,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: new InputDecoration(
          prefixIcon: (Icon(icon, color: Colors.black)),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
          // contentPadding: const EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0, left: 15.0),
          errorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)),
            borderSide: const BorderSide(color: Colors.white, width: 0.0),
          ),
        ),
      ),
    ));
  }
}
