import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/Search%20Bar/search_bar_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SearchBarWidget extends StatelessWidget {
 const SearchBarWidget({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<SearchBarWidgetViewModel>.reactive(
     builder: (context, model, child) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: !AppStateNotifier.isDarkModeOn
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
                        focusNode: model.searchBarFocus,
                        onTap: () {
                          model.setSearchingState(true);
                        },
                        controller: model.searchTextController,
                        cursorColor:
                            !AppStateNotifier.isDarkModeOn ? Colors.black : Colors.white,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            hintText: 'Search torrent by name'),
                      ),
                    ),
                    model.isSearching
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              model.searchTextController.clear();
                              model.searchBarFocus.unfocus();
                              model.setSearchingState(false);
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
                    isScrollControlled: true,
                    builder: (context) {
                      //TODO sort bottom sheet
                      // return SortBottomSheet();
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
      ),
     viewModelBuilder: () => SearchBarWidgetViewModel(),
   );
 }
}