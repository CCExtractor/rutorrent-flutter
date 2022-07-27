// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/shared/app_config.dart';
import 'package:rutorrentflutter/ui/views/IRSSI/IRSSI_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/document_type_card.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

Logger log = getLogger("IRSSIView");

class IRSSIView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var subtitle1 = Theme.of(context).textTheme.subtitle1?.copyWith(
          fontSize: 15,
          color: (AppStateNotifier.isDarkModeOn) ? Colors.white : Colors.black,
        );
    return ViewModelBuilder<IRSSIViewModel>.reactive(
      onModelReady: (model) async => await model.irssiLoad(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Autodl IRSSI Notification Stream'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: false,
                maintainState: true,
                child: Container(
                  height: 1,
                  width: 1,
                  child: WebViewPlus(
                    onWebViewCreated: (controller) async {
                      log.e("onWebViewCreated");
                      await model.onWebViewCreated(controller);
                    },
                    onPageFinished: (url) async {
                      log.e("onPageFinished");
                      await model.onPageFinished(url);
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Wrap(
                    children: [
                      DocumentTypeCard(
                        title: "Update",
                        icon: Icon(
                          Icons.description,
                          color: model.irssiType == IrssiButtons.update
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected: model.irssiType == IrssiButtons.update,
                        onPressed: () {
                          model.setIrssiType(IrssiButtons.update);
                        },
                      ),
                      DocumentTypeCard(
                        title: "Whats New?",
                        icon: Icon(
                          Icons.help_center,
                          color: model.irssiType == IrssiButtons.whatsnew
                              ? Colors.white
                              : Colors.black,
                        ),
                        isQuestionPaper: true,
                        isSelected: model.irssiType == IrssiButtons.whatsnew,
                        onPressed: () {
                          model.setIrssiType(IrssiButtons.whatsnew);
                        },
                      ),
                      DocumentTypeCard(
                        title: "Version",
                        icon: Icon(
                          Icons.event_note,
                          color: model.irssiType == IrssiButtons.version
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected: model.irssiType == IrssiButtons.version,
                        onPressed: () {
                          model.setIrssiType(IrssiButtons.version);
                        },
                      ),
                      DocumentTypeCard(
                        title: "Reload",
                        icon: Icon(
                          Icons.link,
                          color: model.irssiType == IrssiButtons.reloadtrackers
                              ? Colors.white
                              : Colors.black,
                        ),
                        isSelected:
                            model.irssiType == IrssiButtons.reloadtrackers,
                        onPressed: () {
                          model.setIrssiType(IrssiButtons.reloadtrackers);
                        },
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: App(context).appScreenHeightWithOutSafeArea(0.006),
              ),
              ValueListenableBuilder(
                  valueListenable: model.loadingPercent,
                  builder: (_, double loading, __) {
                    print(loading);
                    return loading < 1.0
                        ? Container(
                            height: 0.5 * MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: new CircularPercentIndicator(
                                radius: 80.0,
                                lineWidth: 17.0,
                                animation: false,
                                percent: loading,
                                center: new Text(
                                  "",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                footer: new Text(
                                  "Loading feed...",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: Colors.purple,
                              ),
                            ))
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                model.feed.isEmpty
                                    ? Container(
                                        // color: Colors.red,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: App(context)
                                                  .appScreenHeightWithOutSafeArea(
                                                      0.17),
                                            ),
                                            Text(
                                              "Nothing to show!",
                                              style: subtitle1,
                                            ),
                                            SizedBox(
                                              height: App(context)
                                                  .appScreenHeightWithOutSafeArea(
                                                      0.06),
                                            ),
                                            FractionallySizedBox(
                                              widthFactor: 0.6,
                                              child: Container(
                                                height: App(context)
                                                    .appHeight(0.05),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    await model.refreshFeed();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .button
                                                        ?.copyWith(
                                                            color:
                                                                Colors.white),
                                                    primary: model
                                                                .irssiButton ==
                                                            IrssiButtons.none
                                                        ? Colors.grey
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 5),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                  ),
                                                  child: new Text(
                                                    model.irssiButton ==
                                                            IrssiButtons.none
                                                        ? "Choose a filter first"
                                                        : "Refresh",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button
                                                        ?.copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  App(context).appHeight(0.15),
                                            ),
                                            SizedBox(
                                              height: App(context)
                                                  .appScreenHeightWithOutSafeArea(
                                                      0.3),
                                            ),
                                            // SizedBox(height: ,),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 0.8 *
                                            MediaQuery.of(context).size.height,
                                        // color: Colors.red,
                                        child: ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            itemCount: model.feed.length,
                                            itemBuilder: (context, index) {
                                              String currFeedContent =
                                                  model.feed[model.feed.length -
                                                      1 -
                                                      index];
                                              var subtitle1 = Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                    fontSize: 15,
                                                    color: (AppStateNotifier
                                                            .isDarkModeOn)
                                                        ? Colors.white
                                                        : Colors.black,
                                                  );
                                              return Container(
                                                // height: 100,
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      AppStateNotifier
                                                              .isDarkModeOn
                                                          ? Theme.of(context)
                                                              .primaryColor
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .background,
                                                ),
                                                width:
                                                    App(context).appWidth(0.4),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.description),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      // padding: EdgeInsets.all(10),
                                                      margin: EdgeInsets.all(3),
                                                      width: App(context)
                                                          .appWidth(0.77),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            currFeedContent,
                                                            style: subtitle1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }))
                              ],
                            ),
                          );
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          tooltip: "Refresh feed",
          onPressed: () async {
            await model.refreshFeed();
          },
        ),
      ),
      viewModelBuilder: () => IRSSIViewModel(),
    );
  }
}
