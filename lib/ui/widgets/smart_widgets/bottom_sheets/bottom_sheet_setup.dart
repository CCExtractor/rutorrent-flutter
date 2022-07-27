// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/bottom_sheet_type.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/text_field_view.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/bottom_sheets/confirm_bottom_sheet/confirm_bottom_sheet_view.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/bottom_sheets/option_bottom_sheet/option_bottom_sheet_view.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/bottom_sheets/sort_bottom_sheet/sort_bottom_sheet_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

void setUpBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        _FloatingBoxBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.sortBottomSheet: (context, sheetRequest, completer) =>
        SortBottomSheetView(
          request: sheetRequest,
          completer: completer,
          screen: Screens.TorrentListViewScreen,
        ),
    BottomSheetType.confirmBottomSheet: (context, sheetRequest, completer) =>
        ConfirmBottomSheetView(request: sheetRequest, completer: completer),
    BottomSheetType.optionBottomSheet: (context, sheetRequest, completer) =>
        OptionBottomSheetView(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _FloatingBoxBottomSheet extends StatelessWidget {
  final TextEditingController textFieldController1 = TextEditingController();
  final SheetRequest request;
  final Function(SheetResponse) completer;
  _FloatingBoxBottomSheet({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomSheetViewModel>.reactive(
      builder: (context, model, child) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (model.errorText.isEmpty ? request.title : model.errorText)!,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: model.errorText.isEmpty
                      ? FontWeight.bold
                      : FontWeight.w300,
                ),
              ),
              SizedBox(height: 10),
              TextFieldView(
                  heading: "",
                  labelText: request.description!,
                  textFieldController: textFieldController1),
              SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () =>
                        completer(SheetResponse(confirmed: false, data: null)),
                    child: Text(
                      request.secondaryButtonTitle!,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FlatButton(
                    onPressed: () =>
                        model.response(completer, textFieldController1.text),
                    child: Text(
                      request.mainButtonTitle!,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    color: Theme.of(context).primaryColor,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => BottomSheetViewModel(),
    );
  }
}

class BottomSheetViewModel extends BaseViewModel {
  String errorText = "";
  bool _ischecked = false;

  bool get ischecked => _ischecked;

  void changeCheckMark(bool val) {
    _ischecked = val;
  }

  response(var func, String responseText) {
    if (responseText.length < 5) {
      errorText =
          "Please explain why you are reporting this document so that admins can take appropriate action";
    } else if (responseText.length > 250) {
      errorText = "Maximum limit of 250 characters exceeded";
    } else {
      func(
        SheetResponse(confirmed: true, responseData: responseText),
      );
    }
  }
}
