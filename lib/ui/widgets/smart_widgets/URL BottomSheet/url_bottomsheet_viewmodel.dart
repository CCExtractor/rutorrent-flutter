import 'package:flutter/material.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/enums/enums.dart';
import 'package:rutorrentflutter/utils/file_picker_service.dart';
import 'package:stacked/stacked.dart';

class URLBottomSheetViewModel extends BaseViewModel {

  FilePickerService _filePickerService = locator<FilePickerService>();

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
  String urlValidator(String input) {
    if (!isValidUrl(input)) {
      return 'Please enter a valid url';
    }
    return null;
  }

  void pickTorrentFile() async {
    String torrentPath = await _filePickerService.selectFile();

    if(torrentPath != null){
      //TODO call api service to add torrent 
    }
  }

  void submit(HomeViewBottomSheetMode mode) {

    if(mode == HomeViewBottomSheetMode.Torrent){
      //TODO connect to service
      //  ApiRequests.addTorrent(api, url);
    }else if(mode == HomeViewBottomSheetMode.RSS) {
      //TODO connect to service
      // await ApiRequests.addRSS(api, url);
    }

  }
}