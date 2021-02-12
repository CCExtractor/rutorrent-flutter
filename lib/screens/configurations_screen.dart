import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/data_input.dart';
import 'package:rutorrentflutter/components/password_input.dart';
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/main_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rutorrentflutter/utilities/preferences.dart';
import '../api/api_conf.dart';

class ConfigurationsScreen extends StatefulWidget {
  @override
  _ConfigurationsScreenState createState() => _ConfigurationsScreenState();
}

class _ConfigurationsScreenState extends State<ConfigurationsScreen> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode urlFocus = FocusNode();
  bool isValidating = false;

  bool matchApi(Api api1, Api api2) {
    if (api1.url == api2.url &&
        api1.username == api2.username &&
        api1.password == api2.password)
      return true;
    else
      return false;
  }

  saveLogin(Api api) async {
    bool alreadyLoggedIn = false;
    List<Api> apis = await Preferences.fetchSavedLogin();

    for (int index = 0; index < apis.length; index++) {
      if (matchApi(apis[index], api)) {
        Fluttertoast.showToast(msg: 'Account already saved');
        alreadyLoggedIn = true;

        // Swap to put active one on first position which will be active by default
        Api swapApi = apis[0];
        apis[0] = apis[index];
        apis[index] = swapApi;
      }
    }

    if (!alreadyLoggedIn) {
      apis.insert(0, api);
      Preferences.saveLogin(apis);
    }

    Navigator.pushReplacement(
        //Navigate to Home Screen
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ));
  }

  _validateConfigurationDetails(Api api) async {
    setState(() {
      isValidating = true;
    });

    if (api.username.toString().isNotEmpty) {
      // Check for network connection when user is trying to connect to an external server
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to Network');
        }
      } on SocketException catch (_) {
        setState(() {
          isValidating = false;
        });
        Fluttertoast.showToast(msg: 'Network Connection Error');
        return;
      }
    }

    var response;
    int total;
    try {
      response = await api.ioClient
          .get(Uri.parse(api.diskSpacePluginUrl), headers: api.getAuthHeader());
      total = jsonDecode(response.body)['total'];
    } catch (e) {
      Fluttertoast.showToast(msg: 'Invalid');
    } finally {
      setState(() {
        isValidating = false;
      });
      if (response != null && total != null) {
        response.statusCode == 200
            ? // SUCCESS
            saveLogin(api)
            : Fluttertoast.showToast(msg: 'Something\'s Wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
      inAsyncCall: isValidating,
      child: GestureDetector(
        onTap: () {
          urlFocus.unfocus();
          usernameFocus.unfocus();
          passwordFocus.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
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
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      color: Provider.of<Mode>(context).isLightMode
                          ? Colors.white
                          : Colors.black,
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
                      onPressed: () {
                        Api api = Provider.of<Api>(context,
                            listen: false); // One call to provider
                        api.setUrl(urlController.text);
                        api.setUsername(usernameController.text);
                        api.setPassword(passwordController.text);
                        _validateConfigurationDetails(api);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
