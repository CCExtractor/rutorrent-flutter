import 'package:flutter/material.dart';
import 'package:rutorrentflutter/enums/player_source.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:stacked_services/stacked_services.dart';

class OptionBottomSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  OptionBottomSheetView({required this.request, required this.completer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
        top: 8,
      ),
      color: AppStateNotifier.isDarkModeOn ? kGreyDT : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'OPEN WITH',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
          ),
          Container(
            height: 200,
            child: ListView(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo/flutter.png'),
                  ),
                  onTap: () {
                    completer(SheetResponse(
                        confirmed: true,
                        responseData: PlayerSource.In_App_Player));
                  },
                  dense: false,
                  title: Text("In-App Player"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo/browser.png'),
                  ),
                  onTap: () {
                    completer(SheetResponse(
                        confirmed: true,
                        responseData: PlayerSource.Web_Browser));
                  },
                  dense: false,
                  title: Text("Web Browser"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
