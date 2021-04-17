import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/general_features.dart';
import '../models/mode.dart';
import '../utilities/constants.dart';
import 'search_bar.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Provider.of<GeneralFeatures>(context, listen: false)
                      .setSortPreference(Sort.values.last);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Clear Filter',
                  style: TextStyle(
                    fontSize: 18,
                    color: Provider.of<Mode>(context, listen: false).isLightMode
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
          Container(
            height: 300,
            child: ListView.builder(
              itemCount: Sort.values.length - 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Provider.of<GeneralFeatures>(context, listen: false)
                        .setSortPreference(Sort.values[index]);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        SearchBar.sortMap[Sort.values[index]],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Radio(
                        groupValue: Provider.of<GeneralFeatures>(context)
                            .sortPreference,
                        value: Sort.values[index],
                        onChanged: (dynamic selected) {
                          Provider.of<GeneralFeatures>(context, listen: false)
                              .setSortPreference(Sort.values[index]);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
