// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

Logger log = getLogger("IRSSIViewModel");

class IRSSIViewModel extends BaseViewModel {
  IApiService _apiService = locator<IApiService>();
  WebViewPlusController? webViewController;

  List<String> feed = [];
  ValueNotifier<double> loadingPercent = new ValueNotifier(0.0);

  IrssiButtons irssiButton = IrssiButtons.update;
  IrssiButtons get irssiType => irssiButton;
  setIrssiType(IrssiButtons val) async {
    irssiButton = val;
    notifyListeners();
    await refreshFeed(floatingButton: true);
  }

  onWebViewCreated(controller) async {
    if (irssiButton == IrssiButtons.none) {
      loadingPercent.value = 1.0;
    }
    try {
      loadingPercent.value = 0.0;
      await irssiLoad();
      loadingPercent.value = 0.25;
      this.webViewController = controller;
      String username = _apiService.account?.username as String;
      String password = _apiService.account?.password as String;
      String accUrl = _apiService.account?.url as String;
      String url =
          "https://$username:$password@${accUrl.replaceFirst('https://', '')}";
      await controller.loadUrl(url, headers: _apiService.getAuthHeader());
      loadingPercent.value = 0.50;
      await irssiLoad();

      //Waiting for IRSSI Command to make changes in the Web UI
      await Future.delayed(Duration(milliseconds: 2500));

      loadingPercent.value = 0.5;
      await refreshFeed();
      if (feed.isEmpty) {
        await refreshFeed();
      }
      loadingPercent.value = 1.0;
    } on Exception catch (e) {
      log.e(e.toString());
      loadingPercent.value = 1.0;
      Fluttertoast.showToast(msg: "Error: Try refreshing again");
    }
  }

  onPageFinished(String url) async {}

  irssiLoad() async {
    if (irssiButton == IrssiButtons.none) {
      return;
    }
    await _apiService.irssiLoad(irssiButton.toString().split(".")[1]);
  }

  refreshFeed({floatingButton = false}) async {
    List<String> currFeed = [];
    if (irssiButton == IrssiButtons.none) {
      return;
    }
    loadingPercent.value = floatingButton ? 0.0 : loadingPercent.value;
    try {
      loadingPercent.value += 0.25;
      await irssiLoad();
      String docu = await webViewController?.webViewController
          .evaluateJavascript('document.documentElement.innerHTML') as String;
      if (floatingButton) {
        loadingPercent.value += 0.5;
      }
      var jsonString = json.decode(docu);
      var dom = parse(jsonString);
      if (dom.getElementById("autodl-log-tbody") != null) {
        for (var child in dom.getElementById("autodl-log-tbody")!.children) {
          currFeed.add(child.text);
          loadingPercent.value += 0.05;
        }
      }
      feed = currFeed;
      loadingPercent.value = floatingButton ? 1.0 : loadingPercent.value;
      if (loadingPercent.value > 1.0) {
        loadingPercent.value = 1.0;
      }
    } on Exception catch (e) {
      log.e(e.toString());
      loadingPercent.value = floatingButton ? 1.0 : loadingPercent.value;
      Fluttertoast.showToast(msg: "Error: Try refreshing again");
    } finally {
      loadingPercent.value = floatingButton ? 1.0 : loadingPercent.value;
    }
  }
}
