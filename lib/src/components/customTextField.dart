import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool isObscure;
  final bool autoFocus;
  final FocusNode focusNode;
  final Function onSubmitted;
  final TextInputAction inputAction;

  CustomTextField({
    Key key,
    this.controller,
    this.icon,
    this.hintText,
    this.isObscure = false,
    this.autoFocus = false,
    this.focusNode,
    this.onSubmitted,
    this.inputAction
  }) : super(key: key);

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
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          controller: widget.controller,
          onSubmitted: widget.onSubmitted,
          textInputAction: widget.inputAction,
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
