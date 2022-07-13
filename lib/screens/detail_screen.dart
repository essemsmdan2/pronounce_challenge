import 'package:flutter/material.dart';
import 'package:pronounce_challenge/screens/selection_screen.dart';
import '../modals/constants.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);
  static String id = "details_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: Row(
              children: [
                Text(
                  'POINTS:',
                  style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              height: 220,
              child: Card(
                elevation: 10,
                color: kPrimaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'FIRST TRY = 2 POINTS ',
                        style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: Colors.white),
                      ),
                      Text(
                        'SECOND TRY= 1 POINTS',
                        style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: Colors.white),
                      ),
                      Text(
                        'LAST TRY= 0,5 POINTS',
                        style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: Colors.white),
                      ),
                      Text(
                        'EVIL WORDS= 0 POINTS',
                        style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 42),
            child: SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'EVIL WORDS CAN BE TRYIED',
                    style: kAppBarTextStyle.copyWith(fontSize: 18, letterSpacing: 2, color: kSecondaryColorStyle),
                  ),
                  Row(
                    children: [
                      Text(
                        'ONCE AGAIN IN ',
                        style: kAppBarTextStyle.copyWith(fontSize: 18, letterSpacing: 2, color: kSecondaryColorStyle),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SelectionScreen.id);
                        },
                        child: Text(
                          'MENU',
                          style: kAppBarTextStyle.copyWith(fontSize: 18, letterSpacing: 2, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
