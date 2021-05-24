import 'package:flutter/material.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/URL%20BottomSheet/url_bottomsheet_view.dart';
class HomeViewFloatingActionButton extends StatelessWidget {
  final int index;
  HomeViewFloatingActionButton(this.index);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.library_add,
            color: Colors.white,
          ),
          onPressed: () {
            if (index == 0) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext bc) {
                    return URLBottomSheetView(
                      dialogHint: 'Enter Torrent Url',
                      mode: HomeViewBottomSheetMode.Torrent,
                    );
                  });
            } else {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext bc) {
                    return URLBottomSheetView(
                      dialogHint: 'Enter Rss Url',
                      mode: HomeViewBottomSheetMode.RSS,
                    );
                  });
            }
          },
        );
  }
}