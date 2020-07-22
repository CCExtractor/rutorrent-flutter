import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataInput extends StatelessWidget {
  final IconData iconData;
  final String hintText;
  final TextEditingController textEditingController;
  final FocusNode focus;
  final onFieldSubmittedCallback;
  final textInputAction;
  final bool showPasteIcon;

  DataInput({this.iconData,this.hintText,this.textEditingController,this.onFieldSubmittedCallback,this.focus,this.textInputAction,this.showPasteIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: iconData!=null?Icon(
                iconData,
                color: Colors.grey[600],
              ):Container(),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      textInputAction: textInputAction,
                      focusNode: focus,
                      onFieldSubmitted: onFieldSubmittedCallback,
                      controller: textEditingController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4,vertical: 10),
                          hintText: hintText),
                    ),
                  ),
                  showPasteIcon??false? IconButton(
                    color: Colors.grey,
                    onPressed: () async{
                      ClipboardData data = await Clipboard.getData('text/plain');
                      if(data!=null)
                        textEditingController.text = data.text.toString();
                    },
                    icon: Icon(Icons.content_paste),
                  ):Container(),
                ],
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
