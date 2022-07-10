// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/splash/splash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: SplashScreen.navigate(
                height: 240,
                name: 'assets/animation/diamond.flr',
                next: (context) => Container(),
                isLoading: true,
                loopAnimation: 'tofro',
                startAnimation: 'tofro',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
              child: Image(
                height: 40,
                image: AssetImage('assets/logo/name_logo.png'),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
