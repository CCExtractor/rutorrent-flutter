import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 50,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 12,
                    width: 80,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 12,
                    width: 120,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                height: 12,
                width: 250,
                color: Colors.grey,
              ),
            ],
          ),
        )
    );
  }
}


