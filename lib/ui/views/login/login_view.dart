// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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
                            )
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
                              backgroundColor: !AppStateNotifier.isDarkModeOn
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
