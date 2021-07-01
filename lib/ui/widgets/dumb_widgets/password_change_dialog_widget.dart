import 'package:flutter/material.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/password_input_widget.dart';

class PasswordChangeDialog extends StatefulWidget {
  final Function onTap;
  final TextEditingController fieldController;
  final int? index;
  PasswordChangeDialog(
      {required this.onTap, required this.fieldController, this.index});

  @override
  _PasswordChangeDialogState createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
        );
      }),
    );
  }
}
