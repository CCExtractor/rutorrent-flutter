import 'package:flutter/material.dart';
import 'package:rutorrentflutter/theme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  Widget loadingEffect(BuildContext context, {int? length}) {
    return Shimmer.fromColors(
      baseColor: !AppStateNotifier.isDarkModeOn ? Colors.grey[300]! : kGreyLT,
      highlightColor:
          !AppStateNotifier.isDarkModeOn ? Colors.grey[100]! : kGreyDT,
      child: ListView.builder(
          itemCount: length ?? 1,
          itemBuilder: (context, index) {
            return LoadingShimmer();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 14,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 12,
            width: 80,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 12,
            width: 100,
            color: Colors.grey,
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 10,
            width: 260,
            color: Colors.grey,
          ),
        ],
      ),
    ));
  }
}
