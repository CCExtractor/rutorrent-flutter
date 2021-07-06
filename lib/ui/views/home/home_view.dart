import 'package:rutorrentflutter/theme/AppStateNotifier.dart';
import 'package:rutorrentflutter/ui/shared/shared_styles.dart';
import 'package:rutorrentflutter/ui/views/FrontPage/front_page_view.dart';
import 'package:rutorrentflutter/ui/views/home/home_viewmodel.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/floating_action_button_widget.dart';
import 'package:rutorrentflutter/ui/widgets/dumb_widgets/frontpageview_appbar_widget.dart';
import 'package:rutorrentflutter/ui/widgets/smart_widgets/drawer/drawer_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: HomeViewAppBar(model.account!, model),
        drawer: DrawerView(),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: model.pageController,
          onPageChanged: (index) {
            model.updateIndex(index);
          },
          children: <Widget>[
            FrontPageView(index: 0),
            FrontPageView(index: 1),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppStateNotifier.isDarkModeOn ? kGreyDT : null,
          selectedItemColor: Theme.of(context).primaryColor,
          currentIndex: model.index,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.rss_feed), label: 'Feeds')
          ],
          onTap: (index) {
            model.updateIndex(index);
            model.pageController.jumpToPage(index);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: HomeViewFloatingActionButton(model.index),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
