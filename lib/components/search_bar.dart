import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/sort_bottom_sheet.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/utilities/constants.dart';

class SearchBar extends StatelessWidget {
  static const Map<Sort, String> sortMap = {
    Sort.name_ascending: 'Name - A to Z',
    Sort.name_descending: 'Name - Z to A',
    Sort.dateAdded: 'Date Added',
    Sort.ratio: 'Ratio',
    Sort.size_ascending: 'Size - Small to Large',
    Sort.size_descending: 'Size - Large to Small',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer2<GeneralFeatures, Mode>(
        builder: (context, general, mode, child) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Provider.of<Mode>(context).isLightMode
                      ? Colors.grey[100]
                      : kGreyDT,
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(fontWeight: FontWeight.w600),
                        focusNode: general.searchBarFocus,
                        onTap: () {
                          general.setSearchingState(true);
                        },
                        controller: general.searchTextController,
                        cursorColor:
                            mode.isLightMode ? Colors.black : Colors.white,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            hintText: 'Search torrent by name'),
                      ),
                    ),
                    general.isSearching
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              general.searchTextController.clear();
                              general.searchBarFocus.unfocus();
                              general.setSearchingState(false);
                            },
                          )
                        : Container(),
                  ],
                ),
                width: double.infinity,
                height: 45,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SortBottomSheet();
                    });
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Icon(FontAwesomeIcons.slidersH, color: Colors.white),
              ),
            )
          ],
        ),
      );
    });
  }
}
