import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/constants.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';

class SearchBar extends StatelessWidget {
  static const Map<Sort, String> sortMap = {
    Sort.name: 'Name',
    Sort.dateAdded: 'Date Added',
    Sort.percentDownloaded: 'Percent Downloaded',
    Sort.downloadSpeed: 'Download Speed',
    Sort.uploadSpeed: 'Upload Speed',
    Sort.ratio: 'Ratio',
    Sort.size: 'Size',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer2<GeneralFeatures,Mode>(builder: (context, general,mode, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.search,
                  color: mode.isLightMode?kDarkGrey:kLightGrey,
                ),
              ),
              Expanded(
                child: TextFormField(
                  focusNode: general.searchBarFocus,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      general.searchBarFocus.unfocus();
                    }
                    general.setSearchingState(
                        general.searchTextController.text.isNotEmpty);
                  },
                  controller: general.searchTextController,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      hintText: 'Search your item by name'),
                ),
              ),
              general.isSearching
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: mode.isLightMode?kDarkGrey:kLightGrey,
                      ),
                      onPressed: () {
                        general.searchTextController.clear();
                        general.searchBarFocus.unfocus();
                        general.setSearchingState(false);
                      },
                    )
                  : PopupMenuButton<Sort>(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.slidersH,
                          color: mode.isLightMode?kDarkGrey:kLightGrey,
                        ),
                      ),
                      onSelected: (selectedChoice) {
                        general.setSortPreference(selectedChoice);
                      },
                      itemBuilder: (BuildContext context) {
                        return Sort.values.map((Sort choice) {
                          return PopupMenuItem<Sort>(
                            enabled: !(general.sortPreference == choice),
                            value: choice,
                            child: Text(SearchBar.sortMap[choice]),
                          );
                        }).toList();
                      },
                    ),
            ],
          ),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      );
    });
  }
}
