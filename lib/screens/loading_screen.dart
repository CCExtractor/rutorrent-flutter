import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rutorrentflutter/api/api_conf.dart';
import 'package:rutorrentflutter/constants.dart';
import 'package:rutorrentflutter/screens/configurations_screen.dart';
import 'package:rutorrentflutter/screens/home_screen.dart';
import 'package:rutorrentflutter/services/preferences.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  _checkSavedLogin() async{
    List<Api> apis = await Preferences.fetchSavedLogin();
    if(apis.isEmpty){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>ConfigurationsScreen()
      ));
    }
    else{
      Api api = Provider.of<Api>(context,listen: false);
      api.setUrl(apis[0].url);
      api.setUsername(apis[0].username);
      api.setPassword(apis[0].password);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>HomeScreen()
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSavedLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitPulse(
          color: kIndigo,
          size: 100,
        ),
      ),
    );
  }
}
