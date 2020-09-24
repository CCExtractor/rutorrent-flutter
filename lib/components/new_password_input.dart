import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';

class NewPasswordInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final FocusNode passwordFocus;
  final bool autoFocus;
  NewPasswordInput(
      {this.textEditingController, this.passwordFocus, this.autoFocus});
  @override
  _NewPasswordInputState createState() => _NewPasswordInputState();
}

class _NewPasswordInputState extends State<NewPasswordInput> {
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
            prefixIcon: Icon(
              Icons.lock_outline,
            ),
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
            labelText: 'Password',
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
        ),
      ),
    );
  }
}
