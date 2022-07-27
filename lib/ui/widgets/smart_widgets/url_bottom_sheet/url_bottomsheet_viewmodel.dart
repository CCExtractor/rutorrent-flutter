// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/state_services/torrent_service.dart';
import 'package:rutorrentflutter/utils/file_picker_service.dart';
import 'package:stacked/stacked.dart';

class URLBottomSheetViewModel extends BaseViewModel {
  FilePickerService? _filePickerService = locator<FilePickerService>();
  TorrentService _torrentService = locator<TorrentService>();
  IApiService _apiService = locator<IApiService>();

  final TextEditingController urlTextController = TextEditingController();
  final FocusNode urlFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  // validating url through regex
  bool isValidUrl(String input) {
    var urlRegex = r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+';
    if (RegExp(urlRegex).hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  // output a invalid error message if url is invalid
  String? urlValidator(String? input) {
    if (!isValidUrl(input!)) {
      return 'Please enter a valid url';
    }
    return null;
  }

  void pickTorrentFile() async {
    String? torrentPath = await _filePickerService!.selectFile();

    if (torrentPath != null) {
      await _apiService.addTorrentFile(torrentPath);
    }
    await Future.delayed(Duration(seconds: 2));
    await _torrentService.refreshTorrentList();
  }

  void submit(HomeViewBottomSheetMode? mode) {
    if (mode == HomeViewBottomSheetMode.Torrent) {
      _apiService.addTorrent(urlTextController.text);
    } else if (mode == HomeViewBottomSheetMode.RSS) {
      _apiService.addRSS(urlTextController.text);
    }
  }
}
