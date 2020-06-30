import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/data_input_widget.dart';
import 'package:rutorrentflutter/constants.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../api/api_conf.dart';
import 'package:http/http.dart' as http;

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

  _validateConfigurationDetails(Api api) async{
    if(api.username.toString().isNotEmpty){
      //check for network connection when user is trying to connect to an external server
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('Connected to Network');
        }
      }
      on SocketException catch (_) {
        setState(() {
          isValidating=false;
        });
        Fluttertoast.showToast(msg: 'Network Connection Error');
        return;
      }
    }

    setState(() {
      isValidating=true;
    });
    var response;
    try {
      response = await http.get(Uri.parse(api.diskSpacePluginUrl),
          headers: {
            'authorization': api.getBasicAuth(),
          });
    }
    catch(e){
      print(e);
      Fluttertoast.showToast(msg: 'Invalid Url');
    }
    finally{
      setState(() {
        isValidating=false;
      });
      if(response!=null){
        response.statusCode==200?//SUCCESS
          //Navigate to Home Screen
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => MultiProvider(
                  providers: [
                    Provider<Api> (create: (context)=>api),
                    ChangeNotifierProvider<GeneralFeatures> (create: (context)=>GeneralFeatures(),),
                  ],
                  child: HomeScreen(api))
          )):
        api.username.toString().isEmpty||api.password.toString().isEmpty?
        Fluttertoast.showToast(msg: 'Please enter username and password'):
        Fluttertoast.showToast(msg: 'Invalid Credentials');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isValidating,
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 120.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/ruTorrent_mobile_logo.png'),
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          DataInput(
                            textEditingController: urlController,
                            hintText: 'Enter url here',
                          ),
                          Text('Example: https://fremicro081.xirvik.com/rtorrent',style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
                      child: Column(
                        children: <Widget>[
                          DataInput(
                            onFieldSubmittedCallback: (v){
                              FocusScope.of(context).requestFocus(passwordFocus);
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
                      color: kBlue,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28,vertical: 16),
                        child: Text('Go',style: TextStyle(color: Colors.white,fontSize: 18),),
                      ),
                      onPressed: (){
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
