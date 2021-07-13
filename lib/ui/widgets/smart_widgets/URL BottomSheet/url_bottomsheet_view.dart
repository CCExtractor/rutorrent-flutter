import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rutorrentflutter/theme/AppStateNotifier.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/data_input_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/URL%20BottomSheet/url_bottomsheet_viewmodel.dart';
import 'package:stacked/stacked.dart';

class URLBottomSheetView extends StatelessWidget {
  final HomeViewBottomSheetMode? mode;
  final String? dialogHint;
  URLBottomSheetView({this.dialogHint, this.mode});

  @override
  Widget build(BuildContext context) {
    double wp = MediaQuery.of(context).size.width;
    return ViewModelBuilder<URLBottomSheetViewModel>.reactive(
      builder: (context, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: wp * 0.35,
            ),
            height: 5,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'Add link',
            style: TextStyle(
                fontSize: 14,
                color: !AppStateNotifier.isDarkModeOn
                    ? Colors.black54
                    : Colors.white),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: model.formKey,
              child: DataInput(
                borderColor: !AppStateNotifier.isDarkModeOn
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                textEditingController: model.urlTextController,
                hintText: dialogHint,
                focus: model.urlFocus,
                validator: model.urlValidator,
                suffixIconButton: IconButton(
                  color: AppStateNotifier.isDarkModeOn
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  onPressed: () async {
                    ClipboardData? data = await Clipboard.getData('text/plain');
                    if (data != null)
                      model.urlTextController.text = data.text.toString();
                    if (model.urlFocus.hasFocus) model.urlFocus.unfocus();
                  },
                  icon: Icon(Icons.content_paste),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  primary: Theme.of(context).primaryColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Text(
                  (mode == HomeViewBottomSheetMode.RSS)
                      ? 'Add RSS Feed'
                      : 'Start Download',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              onPressed: () {
                if (model.formKey.currentState.validate()) {
                  model.submit(mode);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          (mode == HomeViewBottomSheetMode.RSS)
              ? Container()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        primary: Theme.of(context).primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                      child: Text(
                        'Browse Torrent File',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    onPressed: () {
                      model.pickTorrentFile();
                      Navigator.pop(context);
                    },
                  ),
                ),
        ],
      ),
      viewModelBuilder: () => URLBottomSheetViewModel(),
    );
  }
}
