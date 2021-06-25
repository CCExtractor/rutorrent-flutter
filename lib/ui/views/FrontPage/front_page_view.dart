import 'package:flutter/material.dart';
import 'package:rutorrentflutter/ui/views/FrontPage/front_page_viewmodel.dart';
import 'package:stacked/stacked.dart';

class FrontPageView extends StatelessWidget {
 final int? index;
 FrontPageView({this.index});

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<FrontPageViewModel>.reactive(
     onModelReady: (model) => model.homeViewPageIndex = index,
     builder: (context, model, child) 
     {
       return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          height: 60,
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () {

                    model.pageController.animateToPage(0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear);
                  },
                  child: Text(
                    model.getTitle(0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: model.currentIndex == 0 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => model.pageController.animateToPage(1,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.linear),
                  child: Text(
                    model.getTitle(1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: model.currentIndex == 1 ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (i) {
              model.changeIndex(i);
            },
            controller: model.pageController,
            children: model.getPagesList(),
          ),
        ),
      ],
    );},
     viewModelBuilder: () => FrontPageViewModel(),
   );
 }
}