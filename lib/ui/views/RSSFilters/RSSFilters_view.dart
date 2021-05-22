import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rutorrentflutter/ui/views/RSSFilters/RSSFilters_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

class RSSFiltersView extends StatelessWidget {
 const RSSFiltersView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<RSSFiltersViewModel>.reactive(
     builder: (context, model, child) => Container(
      height: 500,
      child: model.isBusy
          ? LoadingShimmer().loadingEffect(context)
          : Column(
              children: <Widget>[
                (model.rssFilters.length != 0)
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: model.rssFilters.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${index + 1}. ${model.rssFilters[index].name}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                          Checkbox(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            onChanged: (val) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Please use ruTorrent web interface to change filter settings');
                                            },
                                            value:
                                                model.rssFilters[index].enabled == 1,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Pattern: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Flexible(
                                                child: Text(
                                                    model.rssFilters[index].pattern)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Label: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Flexible(
                                                child: Text(
                                                    model.rssFilters[index].label)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Exclude: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Flexible(
                                                child: Text(
                                                    model.rssFilters[index].exclude)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Save Directory: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Flexible(
                                                child: Text(
                                                    model.rssFilters[index].dir)),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    : Expanded(
                        child: Center(
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.light
                              ? 'assets/logo/empty.svg'
                              : 'assets/logo/empty_dark.svg',
                          width: 120,
                          height: 120,
                        ),
                      )),
              ],
            ),
    ),
     viewModelBuilder: () => RSSFiltersViewModel(),
   );
 }
}