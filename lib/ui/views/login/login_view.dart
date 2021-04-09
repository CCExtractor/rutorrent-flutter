import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rutorrentflutter/AppTheme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/views/login/login_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/data_input.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/password_input.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
 final TextEditingController urlController = TextEditingController(); 
 final TextEditingController usernameController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 final FocusNode usernameFocus = FocusNode();
 final FocusNode passwordFocus = FocusNode();
 final FocusNode urlFocus = FocusNode();
 
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
          appBar: AppBar(
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
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
                              image: AssetImage('assets/logo/white_logo.png'),
                              height: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DataInput(
                          borderColor: Colors.white,
                          textEditingController: urlController,
                          hintText: 'Location of ruTorrent',
                          hintTextColor: Colors.white54,
                          focus: urlFocus,
                          suffixIconButton: IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              ClipboardData data =
                                  await Clipboard.getData('text/plain');
                              if (data != null)
                                urlController.text = data.text.toString();
                              if (urlFocus.hasFocus) urlFocus.unfocus();
                            },
                            icon: Icon(Icons.content_paste),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        primary: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        child: Text(
                          'Let\'s get started',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18),
                        ),
                      ),
                      onPressed: () async {
                        await model.login(
                          url: urlController.text.trim(),
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                        );
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
     viewModelBuilder: () => LoginViewModel(),
   );
 }
}