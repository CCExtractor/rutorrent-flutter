import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/general_features.dart';
import 'search_bar.dart';

class SortBottomSheet extends StatefulWidget {
  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SORT BY',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: Sort.values.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Provider.of<GeneralFeatures>(context, listen: false)
                          .setSortPreference(Sort.values[index]);
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
                          onChanged: (selected) {
                            Provider.of<GeneralFeatures>(context, listen: false)
                                .setSortPreference(Sort.values[index]);
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
      ),
    );
  }
}
