import 'package:flutter/material.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/password_input_widget.dart';

class PasswordChangeBottomSheet extends StatefulWidget {
  final Function onTap;
  final TextEditingController fieldController;
  final int? index;
  PasswordChangeBottomSheet(
      {required this.onTap, required this.fieldController, this.index});

  @override
  _PasswordChangeBottomSheetState createState() =>
      _PasswordChangeBottomSheetState();
}

class _PasswordChangeBottomSheetState extends State<PasswordChangeBottomSheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // removing dialog widget
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        // padding added
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 8.0,
          right: 8.0,
          left: 8.0,
        ),
        child: Column(
          // minimizing to size
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 8.0,
                top: 8.0,
                right: 8.0,
                left: 8.0,
              ),
              child: PasswordInput(
                textEditingController: widget.fieldController,
                autoFocus: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: !AppStateNotifier.isDarkModeOn
                              ? Colors.white
                              : kGreyDT,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        child: Text(
                          'VALIDATE',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          widget.onTap(
                              widget.fieldController.text, widget.index);
                        },
                      ),
                    ),
            )
          ],
        ),
      );
    });
  }
}
