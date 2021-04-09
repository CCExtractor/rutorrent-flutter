import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/models/disk_space.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';

class ShowDiskSpace extends StatelessWidget {
  DiskSpace diskSpace;
  ShowDiskSpace(this.diskSpace);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Disk Space (${diskSpace.getPercentage()}%)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
                '${filesize(diskSpace.free)} left of ${filesize(diskSpace.total)}',
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'SFUIDisplay/sf-ui-display-medium.otf')),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 8,
              child: LinearProgressIndicator(
                value: diskSpace.getPercentage() / 100,
                backgroundColor: Theme.of(context).disabledColor,
                valueColor:
                    AlwaysStoppedAnimation<Color>(diskSpace.isLow()
                        ? AppStateNotifier.isDarkModeOn
                            ? kRedErrorLT
                            : kRedErrorDT
                        : Theme.of(context).accentColor),
              ),
            )
          ],
        ),
      );
  }
}
