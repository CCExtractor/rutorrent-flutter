import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/services/functional_services/api_service.dart';
import 'package:rutorrentflutter/utils/file_picker_service.dart';
import 'package:stacked/stacked.dart';

class URLBottomSheetViewModel extends BaseViewModel {
  FilePickerService? _filePickerService = locator<FilePickerService>();
  ApiService _apiService = locator<ApiService>();

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
    String? torrentPath =
        await (_filePickerService!.selectFile() as Future<String?>);

    if (torrentPath != null) {
      _apiService.addTorrentFile(torrentPath);
    }
  }

  void submit(HomeViewBottomSheetMode? mode) {
    if (mode == HomeViewBottomSheetMode.Torrent) {
       _apiService.addTorrent(urlTextController.text);
    } else if (mode == HomeViewBottomSheetMode.RSS) {
      _apiService.addRSS(urlTextController.text);
    }
  }
}
