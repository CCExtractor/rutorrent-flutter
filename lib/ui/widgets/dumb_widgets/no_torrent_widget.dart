import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoTorrentWidget extends StatelessWidget {
  const NoTorrentWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/logo/empty.svg'
                : 'assets/logo/empty_dark.svg',
            width: 120,
            height: 120,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'No Torrents to Show',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
