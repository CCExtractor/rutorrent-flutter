import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/data_input_widget.dart';
import 'package:rutorrentflutter/constants.dart' as Constants;
import 'package:rutorrentflutter/models/mode.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../api/api_conf.dart';

class ConfigurationsScreen extends StatefulWidget {
  @override
  _ConfigurationsScreenState createState() => _ConfigurationsScreenState();
}

class _ConfigurationsScreenState extends State<ConfigurationsScreen> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  bool isValidating = false;
  Api api = Api();

  _validateConfigurationDetails(Api api) async {
    if (api.username.toString().isNotEmpty) {
      //check for network connection when user is trying to connect to an external server
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

    setState(() {
      isValidating = true;
    });
    var response;
    int total;
    try {
      response = await api.ioClient
          .get(Uri.parse(api.diskSpacePluginUrl), headers: api.getAuthHeader());
      total = jsonDecode(response.body)['total'];
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Invalid');
    } finally {
      setState(() {
        isValidating = false;
      });
      if (response != null && total != null) {
        response.statusCode == 200
            ? //  SUCCESS: Validation Successful
            //Navigate to Home Screen
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Provider(create: (context) => api, child: HomeScreen()),
                ))
            : Fluttertoast.showToast(msg: 'Something\'s Wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
            Provider.of<Mode>(context).isLightMode
                ? Constants.kBlue
                : Constants.kIndigo),
      ),
      inAsyncCall: isValidating,
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 120.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Image(
                      image: Provider.of<Mode>(context).isLightMode
                          ? AssetImage('assets/logo/light_mode.png')
                          : AssetImage('assets/logo/dark_mode.png'),
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          DataInput(
                            showPasteIcon: true,
                            textEditingController: urlController,
                            hintText: 'Enter url here',
                          ),
                          Text(
                            'Example: https://fremicro081.xirvik.com/rtorrent',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 32.0),
                      child: Column(
                        children: <Widget>[
                          DataInput(
                            onFieldSubmittedCallback: (v) {
                              FocusScope.of(context)
                                  .requestFocus(passwordFocus);
                            },
                            textEditingController: usernameController,
                            iconData: FontAwesomeIcons.user,
                            hintText: 'Username',
                            textInputAction: TextInputAction.next,
                          ),
                          DataInput(
                            focus: passwordFocus,
                            textEditingController: passwordController,
                            iconData: FontAwesomeIcons.userSecret,
                            hintText: 'Password',
                          ),
                        ],
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(),
                      ),
                      color: Constants.kBlue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 16),
                        child: Text(
                          'Go',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      onPressed: () {
                        api.setUrl(urlController.text);
                        api.setUsername(usernameController.text);
                        api.setPassword(passwordController.text);
                        _validateConfigurationDetails(api);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
