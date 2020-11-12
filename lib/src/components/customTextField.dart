import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChangedValue;
  final IconData icon;
  final String hintText;
  final bool isObscure;

  CustomTextField({Key key, this.onChangedValue, this.icon, this.hintText, this.isObscure = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        width: size.width * 0.8,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
        ),
        child: TextField(
          onChanged: onChangedValue,
          obscureText: isObscure,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 17),
            hintText: hintText,
            prefixIcon: icon != null ? Icon(
              icon,
              color: Colors.amber,
            ) : null,
            suffixIcon: isObscure ? Icon(Icons.visibility) : null,
            border: InputBorder.none,
          ),
        )
    );
  }
}
