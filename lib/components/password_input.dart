import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode passwordFocus;
  final bool autoFocus;
  PasswordInput(
      {this.textEditingController, this.passwordFocus, this.autoFocus});
  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: TextFormField(
          style: TextStyle(fontWeight: FontWeight.w600),
          autofocus: widget.autoFocus != null ? widget.autoFocus : false,
          obscureText: !passwordVisible,
          focusNode: widget.passwordFocus,
          controller: widget.textEditingController,
          cursorColor: Provider.of<Mode>(context).isLightMode
              ? Colors.black
              : Colors.white,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: 'Password',
            suffixIcon: IconButton(
              color: Colors.grey,
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  passwordVisible = !passwordVisible;
                });
              },
            ),
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
