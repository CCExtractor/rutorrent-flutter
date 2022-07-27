// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/media_player/media_stream_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MediaStreamView extends StatelessWidget {
  final String mediaUrl;
  final String mediaName;
  final String path;
  MediaStreamView({
    required this.mediaName,
    required this.mediaUrl,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MediaStreamViewModel>.reactive(
      onModelReady: (model) => model.init(mediaUrl, path),
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: model.isAndroid
              ? WebView(
                  initialUrl: mediaUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                )
              : Center(
                  child: model.chewieController != null &&
                          model.chewieController!.videoPlayerController.value
                              .isInitialized
                      ? Chewie(
                          controller: model.chewieController!,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 20),
                            Text('Loading'),
                          ],
                        ),
                ),
        ),
      ),
      viewModelBuilder: () => MediaStreamViewModel(),
    );
  }
}
