import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'data_input.dart';

class AddBottomSheet extends StatelessWidget {
  final Function apiRequest;
  final String dialogHint;
  final TextEditingController urlTextController = TextEditingController();
  final FocusNode urlFocus = FocusNode();
  AddBottomSheet({@required this.apiRequest, @required this.dialogHint});
  @override
  Widget build(BuildContext context) {
    double wp = MediaQuery.of(context).size.width;
    double hp = MediaQuery.of(context).size.height;
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: wp * 0.35,
            ),
            height: 5,
            color: Color(0xffE8E8E8),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Add link',
            style: TextStyle(
                fontSize: 14,
                color: Provider.of<Mode>(context).isLightMode
                    ? Colors.black54
                    : Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: DataInput(
              borderColor: Provider.of<Mode>(context).isLightMode
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              textEditingController: urlTextController,
              hintText: dialogHint,
              focus: urlFocus,
              suffixIconButton: IconButton(
                color: Provider.of<Mode>(context).isLightMode
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                onPressed: () async {
                  ClipboardData data = await Clipboard.getData('text/plain');
                  if (data != null)
                    urlTextController.text = data.text.toString();
                  if (urlFocus.hasFocus) urlFocus.unfocus();
                },
                icon: Icon(Icons.content_paste),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            width: double.infinity,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Text(
                  'Start Download',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onPressed: () {
                apiRequest(urlTextController.text);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
