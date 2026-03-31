// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rutorrentflutter/services/functional_services/discovery_service.dart';
import 'package:rutorrentflutter/theme/app_state_notifier.dart';
import 'package:rutorrentflutter/ui/views/login/login_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/data_input_widget.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/password_input_widget.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode urlFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void _showDiscoveryDialog(
      BuildContext context, LoginViewModel model) async {
    // Show dialog immediately with loading state
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(minHeight: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discover Servers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          setModalState(() {});
                          model.discoverServers().then((_) {
                            setModalState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Searching for ruTorrent servers on your local network...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  ValueListenableBuilder<bool>(
                    valueListenable: model.isDiscovering,
                    builder: (context, isDiscovering, _) {
                      if (isDiscovering) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ValueListenableBuilder<List<DiscoveredServer>>(
                        valueListenable: model.discoveredServers,
                        builder: (context, servers, _) {
                          if (servers.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'No servers found',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Make sure your server is configured\nwith Avahi/mDNS discovery.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: servers.length,
                            itemBuilder: (context, index) {
                              final server = servers[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.dns_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                title: Text(
                                  server.name ?? server.host,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(server.url),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  urlController.text = server.url;
                                  Navigator.pop(bottomSheetContext);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Start discovery after showing the dialog
    model.discoverServers();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
        inAsyncCall: model.isBusy,
        child: GestureDetector(
          onTap: () {
            urlFocus.unfocus();
            usernameFocus.unfocus();
            passwordFocus.unfocus();
          },
          child: Scaffold(
            backgroundColor: AppStateNotifier.isDarkModeOn
                ? Theme.of(context).primaryColor
                : Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: AppStateNotifier.isDarkModeOn
                          ? Colors.black
                          : Theme.of(context).primaryColor,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 24.0,
                                ),
                                child: Image(
                                  image: !AppStateNotifier.isDarkModeOn
                                      ? AssetImage('assets/logo/white_logo.png')
                                      : AssetImage('assets/logo/dark_mode.png'),
                                  height: 50,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              key: _formKey,
                              child: DataInput(
                                borderColor: Colors.white,
                                textEditingController: urlController,
                                hintText: 'Location of ruTorrent',
                                hintTextColor: Colors.white54,
                                focus: urlFocus,
                                validator: model.urlValidator,
                                suffixIconButton: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    ClipboardData? data =
                                        await Clipboard.getData('text/plain');
                                    if (data != null)
                                      urlController.text = data.text.toString();
                                    if (urlFocus.hasFocus) urlFocus.unfocus();
                                  },
                                  icon: Icon(Icons.content_paste),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.info_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Check your browser address bar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Discover Servers button
                            TextButton.icon(
                              onPressed: () =>
                                  _showDiscoveryDialog(context, model),
                              icon: Icon(
                                Icons.wifi_find,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: Text(
                                'Discover Servers on Network',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                side: BorderSide(
                                    color: Colors.white54, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataInput(
                        onFieldSubmittedCallback: (v) {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
                        focus: usernameFocus,
                        textEditingController: usernameController,
                        hintText: 'Username',
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PasswordInput(
                        textEditingController: passwordController,
                        passwordFocus: passwordFocus,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                              primary: !AppStateNotifier.isDarkModeOn
                                  ? Colors.white
                                  : Colors.black),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 16),
                            child: Text(
                              'Let\'s get started',
                              style: TextStyle(
                                  color: !AppStateNotifier.isDarkModeOn
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  fontSize: 18),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await model.login(
                                url: urlController.text.trim(),
                                username: usernameController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
