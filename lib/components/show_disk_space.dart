import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;

class ShowDiskSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<GeneralFeatures, Mode>(
        builder: (context, general, mode, child) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Disk Space (${general.diskSpace.getPercentage()}%)',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'SFUIDisplay/sf-ui-display-high.otf'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  '${filesize(general.diskSpace.free)} left of ${filesize(general.diskSpace.total)}',
                  style: TextStyle(
                      fontSize: 14,
                      color: mode.isLightMode
                          ? Constants.kDarkGrey
                          : Constants.kLightGrey,
                      fontFamily: 'SFUIDisplay/sf-ui-display-medium.otf')),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 10,
                child: LinearProgressIndicator(
                  value: general.diskSpace.getPercentage() / 100,
                  backgroundColor: Constants.kLightGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      general.diskSpace.isLow()
                          ? Constants.kRed
                          : Constants.kBlue),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
