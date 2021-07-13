import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilePickerService {
  Future selectFile() async {
    String? torrentPath;
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["torrent"]);
    if (result == null) {
      Fluttertoast.showToast(msg: 'No file selected');
    } else if (result.files.first.extension == "torrent") {
      torrentPath = result.files.first.path;
      print("path: $torrentPath");
      return torrentPath;
    } else {
      Fluttertoast.showToast(msg: 'Invalid file selected');
    }
  }
}
