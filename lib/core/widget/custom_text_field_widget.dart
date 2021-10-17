import 'package:fangapp/core/theme/app_colors.dart';
import 'package:fangapp/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    Key? key,
    required this.focusNode,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.icon,
    required this.hintText,
    this.isObscure = false,
    this.autoFocus = false,
    this.inputAction,
    this.maxLength,
    this.showMaxLengthCount = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.enableInteractiveSelection = true,
  }) : super(key: key);

  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final IconData? icon;
  final String hintText;
  final bool isObscure;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final int? maxLength;
  final bool showMaxLengthCount;
  final TextInputType keyboardType;
  final bool enabled;
  final bool enableInteractiveSelection;

  @override
  _CustomTextFieldWidgetState createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isVisible = !widget.isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextField(
        enabled: widget.enabled,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.maxLength != null
            ? <LengthLimitingTextInputFormatter>[
                LengthLimitingTextInputFormatter(widget.maxLength),
              ]
            : <LengthLimitingTextInputFormatter>[],
        autofocus: widget.autoFocus,
        controller: widget.controller,
        onChanged: widget.onChanged,
        focusNode: widget.focusNode,
        obscureText: !_isVisible,
        onSubmitted: widget.onSubmitted,
        style: AppStyles.regularText(
          context,
          size: 12,
          color: AppColors.blackSmokeDark,
        ),
        textInputAction: widget.inputAction,
        cursorColor: AppColors.blackSmokeDark,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          labelStyle: AppStyles.mediumTitle(
            context,
            color: AppColors.blueLight,
          ),
          filled: true,
          fillColor: Colors.transparent,
          labelText: widget.hintText,
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 2, color: AppColors.blackSmokeLight),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: AppColors.blackSmokeDark,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: !widget.isObscure
              ? null
              : IconButton(
                  icon: Icon(
                    Icons.visibility,
                    color: _isVisible
                        ? AppColors.orange
                        : AppColors.blackSmokeLight,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  iconSize: 20,
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
                ),
          suffix: widget.maxLength != null && widget.showMaxLengthCount
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${widget.controller.text.length.toString()}/${widget.maxLength}',
                    style: AppStyles.regularText(
                      context,
                      size: 12,
                      color: AppColors.blackSmokeDark,
                    ),
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
