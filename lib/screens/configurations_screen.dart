import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rutorrentflutter/components/data_input_widget.dart';
import 'package:rutorrentflutter/constants.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import '../api_conf.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 80.0),
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
                          iconData: FontAwesomeIcons.solidAddressCard,
                          hintText: 'Enter url here',
                        ),
                        Text('Example: https://fremicro081.xirvik.com/rtorrent/',style: TextStyle(color: Colors.grey),),
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
                    color: kBlue,
                    child: Text('Go',style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      Api api = Api(urlController.text);
                      api.setUsername(usernameController.text);
                      api.setPassword(passwordController.text);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => HomeScreen(api)
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
