// ignore_for_file: import_of_legacy_library_into_null_safe, deprecated_member_use

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rutorrentflutter/app/app.locator.dart';
import 'package:rutorrentflutter/app/app.logger.dart';
import 'package:rutorrentflutter/app/app.router.dart';
import 'package:rutorrentflutter/enums/bottom_sheet_type.dart';
import 'package:rutorrentflutter/enums/player_source.dart';
import 'package:rutorrentflutter/models/account.dart';
import 'package:rutorrentflutter/models/disk_file.dart';
import 'package:rutorrentflutter/services/api/i_api_service.dart';
import 'package:rutorrentflutter/services/state_services/file_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

final log = getLogger("DiskFileTileViewModel");

class DiskFileTileViewModel extends BaseViewModel {
  FileService _fileService = locator<FileService>();
  IApiService _apiService = locator<IApiService>();
  NavigationService _navigationService = locator<NavigationService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  late DiskFile diskFile;
  late String path;
  int _progress = 0;
  CancelToken cancelToken = CancelToken();

  get progress => _progress;

  onTap(DiskFile diskFile, goBackwards, goForwards) {
    if (diskFile.isDirectory ?? true) {
      diskFile.name == '..' ? goBackwards() : goForwards(diskFile.name);
    } else {
      if (_fileService.isAudio(diskFile.name!) ||
          _fileService.isVideo(diskFile.name!)) {
        _streamFile();
      } else {
        Fluttertoast.showToast(msg: 'Not a Streamable File');
      }
    }
  }

  getFileIcon(String? name) {
    return _fileService.getFileIcon(name!);
  }

  downloadFile() async {
    setBusy(true);
    String fileUrl = _getDiskFileUrl();

    // finding torrent or folder name
    path = path.substring(0, path.length - 1);
    path = path.substring(path.lastIndexOf('/'));

    // finding directory in local to save the file
    Directory? dir = await getExternalStorageDirectory();
    String savePath = '${dir?.path}/$path/${diskFile.name}';

    Dio dio = Dio();

    dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (rcv, total) {
        print(
            'Received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        _progress = ((rcv * 100 ~/ total));
        notifyListeners();
      },
      cancelToken: cancelToken,
    ).then((_) {
      notifyListeners();
      Fluttertoast.showToast(msg: 'Download Successful');
      setBusy(false);
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(msg: 'Error in downloading file');
      setBusy(false);
    });
  }

  init(diskFileArgument, pathArgument) {
    diskFile = diskFileArgument;
    path = pathArgument;
  }

  String _getDiskFileUrl() {
    Account account = _apiService.account ?? Account();
    Uri uri = Uri.parse(account.url!);
    String fileUrl = uri.scheme +
        '://' +
        (account.username)! +
        ':' +
        (account.password)! +
        '@' +
        uri.authority +
        '/downloads' +
        path +
        (diskFile.name)!;
    fileUrl = Uri.encodeFull(fileUrl);
    return fileUrl;
  }

  _streamFile() async {
    String fileUrl = _getDiskFileUrl();
    SheetResponse? sheetResponse = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.optionBottomSheet,
    );
    if (sheetResponse?.confirmed ?? false) {
      Fluttertoast.showToast(msg: 'Streaming File');
      switch (sheetResponse!.responseData) {
        case PlayerSource.In_App_Player:
          {
            _navigationService.navigateTo(Routes.mediaStreamView,
                arguments: MediaStreamViewArguments(
                    mediaName: diskFile.name!, mediaUrl: fileUrl, path: path));
            break;
          }
        case PlayerSource.Web_Browser:
          {
            if (await canLaunch(fileUrl)) {
              await launch(
                fileUrl,
                enableJavaScript: true,
                forceSafariVC: true,
                forceWebView: false,
              );
            } else {
              Fluttertoast.showToast(msg: "Unable to Stream File");
              throw 'Could not launch $fileUrl';
            }
            break;
          }
      }
    }
  }

  clearButtonOnTap() {
    cancelToken.cancel();
    cancelToken = CancelToken();
    setBusy(false);
  }
}
