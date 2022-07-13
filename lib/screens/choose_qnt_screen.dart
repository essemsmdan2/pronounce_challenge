import 'package:flutter/material.dart';
import 'package:pronounce_challenge/api/admob_manager.dart';
import '../modals/constants.dart';
import 'challenge_screen.dart';

class ChooseQnt extends StatelessWidget {
  AdManager admob = AdManager();
  static String id = "Choose Qnt";
  ChooseQnt({Key? key}) : super(key: key) {
    admob.addAds(false, true, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'HOW MANY',
          style: kAppBarTextStyle,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeScreen(challengeQnt: 5))),
                    child: Text(
                      'WORDS "05"',
                      style: kAppBarTextStyle,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeScreen(challengeQnt: 10))),
                    child: Text(
                      'WORDS "10"',
                      style: kAppBarTextStyle,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeScreen(challengeQnt: 20))),
                    child: Text(
                      'WORDS "20"',
                      style: kAppBarTextStyle,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChallengeScreen(challengeQnt: 30))),
                    child: Text(
                      'WORDS "30"',
                      style: kAppBarTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          admob.showBannerWidget(context)
        ],
      ),
    );
  }
}
