import 'package:flutter/material.dart';

class DataInput extends StatelessWidget {
  final IconData iconData;
  final String hintText;
  final TextEditingController textEditingController;

  DataInput({this.iconData,this.hintText,this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                iconData,
                color: Colors.grey[600],
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    hintText: hintText),
              ),
            ),
          ],
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey,width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
      ),
    )
    ;
  }
}
