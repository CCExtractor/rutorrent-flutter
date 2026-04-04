// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/bottom_sheets/sort_bottom_sheet/sort_bottom_sheet_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SortBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Screens screen;
  SortBottomSheetView(
      {required this.request, required this.completer, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SortBottomSheetViewModel>.reactive(
      onModelReady: (model) => model.init(screen),
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          top: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'SORT BY',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                TextButton(
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  onPressed: () {
                    model.setSortPreference(completer, Sort.values.last);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Clear Filter',
                    style: TextStyle(
                      fontSize: 18,
                      color: !AppStateNotifier.isDarkModeOn
                          ? kBluePrimaryLT
                          : kPrimaryDT,
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            RadioGroup<Sort>(
              groupValue: model.sortPreference,
              onChanged: (Sort? selected) {
                if (selected != null) {
                  model.setSortPreference(completer, selected);
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                height: 300,
                child: ListView.builder(
                  itemCount: Sort.values.length - 1,
                  itemBuilder: (context, index) {
                    Map<Sort, String> sortMap = model.getSortMap();
                    return sortMap[Sort.values[index]] == null
                        ? Container()
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              model.setSortPreference(
                                  completer, Sort.values[index]);
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  sortMap[Sort.values[index]]!,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Radio<Sort>(
                                  value: Sort.values[index],
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => SortBottomSheetViewModel(),
    );
  }
}
