import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';

class DataInput extends StatelessWidget {
  final String hintText;
  final Color hintTextColor;
  final TextEditingController textEditingController;
  final FocusNode focus;
  final IconButton suffixIconButton;
  final onFieldSubmittedCallback;
  final textInputAction;
  final Color borderColor;

  DataInput({
    this.hintText,
    this.hintTextColor,
    this.textEditingController,
    this.onFieldSubmittedCallback,
    this.focus,
    this.textInputAction,
    this.suffixIconButton,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextFormField(
          style: TextStyle(fontWeight: FontWeight.w600, color: borderColor),
          textInputAction: textInputAction,
          focusNode: focus,
          onFieldSubmitted: onFieldSubmittedCallback,
          controller: textEditingController,
          cursorColor: borderColor != null
              ? borderColor
              : Provider.of<Mode>(context).isLightMode
                  ? Colors.black
                  : Colors.white,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: hintText,
            hintStyle: TextStyle(color: hintTextColor ?? borderColor),
            suffixIcon: suffixIconButton,
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: borderColor != null ? borderColor : Colors.grey,
                width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
