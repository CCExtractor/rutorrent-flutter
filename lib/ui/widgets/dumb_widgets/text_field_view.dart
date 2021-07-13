import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';

class TextFieldView extends StatelessWidget {
  final String heading;
  final String labelText;
  final TextEditingController textFieldController;
  TextFieldView(
      {required this.heading,
      required this.labelText,
      required this.textFieldController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          heading,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Card(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60,
            child: TextFormField(
              // maxLines:
              controller: textFieldController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
                letterSpacing: -0.03,
                fontFamily: 'Montserrat',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                ),
                hintText: labelText,
                // hintStyle: kHintTextStyle,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter $heading .';
                } else if ((value?.length ?? 0) < 3) {
                  return "Please enter valid $heading";
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
