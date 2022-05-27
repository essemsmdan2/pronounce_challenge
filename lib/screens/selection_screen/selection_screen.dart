import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen/challenge_screen.dart';
import 'package:pronounce_challenge/screens/evil_words/evil_words_challenge.dart';
import 'package:pronounce_challenge/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SelectionScreen extends StatefulWidget {
  static String id = "Selection Screen";
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBanner.load();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<ChallengeData>(context, listen: false).updateEvilWordsFromSharedPreferences();

      if (Provider.of<ChallengeData>(context, listen: false).evilWordArray.isNotEmpty) {
        print(Provider.of<ChallengeData>(context, listen: false).evilWordArray);
        Provider.of<ChallengeData>(context, listen: false).setShowEvilWordMenu(true);
      } else {
        Provider.of<ChallengeData>(context, listen: false).setShowEvilWordMenu(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: Text(
          'CHALLENGES',
          style: kAppBarTextStyle.copyWith(fontSize: 25),
        ),
      ),
      body: Consumer<ChallengeData>(
        builder: (BuildContext context, chData, Widget? child) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, ChallengeScreen.id),
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
                      ElevatedButton(
                        onPressed: null,
                        child: Text(
                          'MULTI LANG(SOON) ',
                          style: kAppBarTextStyle,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: chData.showEvilWordsMenu
                            ? () {
                                Navigator.pushNamed(context, EvilWordsScreen.id);
                              }
                            : null,
                        child: Text(
                          'EVIL WORDS',
                          style: kAppBarTextStyle,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, OnBoardingPage.id);
                        },
                        child: Text(
                          'TUTORIAL ',
                          style: kAppBarTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: AdWidget(ad: myBanner),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
