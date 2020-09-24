import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';

class NewDataInput extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final FocusNode focus;
  final IconButton suffixIconButton;
  final onFieldSubmittedCallback;
  final textInputAction;
  final Color borderColor;

  NewDataInput(
      {this.hintText,
      this.textEditingController,
      this.onFieldSubmittedCallback,
      this.focus,
      this.textInputAction,
      this.suffixIconButton,
      this.borderColor});

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
            prefixIcon: Icon(
              Icons.perm_identity,
            ),
            labelText: hintText,
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff809FBF).withOpacity(0.6),
              ),
            ),
          ),
//          InputDecoration(
//            border: InputBorder.none,
//            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//            hintText: hintText,
//            hintStyle: TextStyle(color: borderColor),
//            suffixIcon: suffixIconButton,
//          ),
        ),
//        decoration: BoxDecoration(
//            border: Border.all(
//                color: borderColor != null ? borderColor : Colors.grey,
//                width: 1.5),
//            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
