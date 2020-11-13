import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String> onChangedValue;
  final IconData icon;
  final String hintText;
  final bool isObscure;

  CustomTextField({Key key, this.onChangedValue, this.icon, this.hintText, this.isObscure = false}) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isVisible;

  @override
  void initState() {
    super.initState();
    setState(() { _isVisible = !widget.isObscure; });
  }

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
          onChanged: widget.onChangedValue,
          obscureText: !_isVisible,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 17),
            hintText: widget.hintText,
            prefixIcon: widget.icon != null ? Icon(
              widget.icon,
              color: Colors.amber,
            ) : null,
            suffixIcon: !widget.isObscure
                ? null
                : IconButton(
                    icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {setState(() { _isVisible = !_isVisible; });},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                ),
            border: InputBorder.none,
          ),
        )
    );
  }
}
