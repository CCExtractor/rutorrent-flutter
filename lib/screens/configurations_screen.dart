import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/components/data_input_widget.dart';
import 'package:rutorrentflutter/constants.dart';
import 'package:rutorrentflutter/models/general_features.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import '../api/api_conf.dart';

class ConfigurationsScreen extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          textEditingController: usernameController,
                          iconData: FontAwesomeIcons.user,
                          hintText: 'Username',
                        ),
                        DataInput(
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
                      Api api = Api(urlController.text);
                      api.setUsername(usernameController.text);
                      api.setPassword(passwordController.text);

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            Provider<Api> (create: (context)=>api),
                            ChangeNotifierProvider<GeneralFeatures> (create: (context)=>GeneralFeatures(),),
                          ],
                            child: HomeScreen(api))
                      ));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
