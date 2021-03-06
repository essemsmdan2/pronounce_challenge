import 'package:flutter/material.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/onboarding_screen.dart';
import 'package:pronounce_challenge/screens/choose_qnt_screen.dart';
import 'package:pronounce_challenge/api/admob_manager.dart';
import 'package:provider/provider.dart';
import '../api/in_app_purchases.dart';
import '../modals/constants.dart';
import 'evil_words_screen.dart';

class SelectionScreen extends StatefulWidget {
  static String id = "Selection Screen";

  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  AdManager admob = AdManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admob.addAds(false, true, false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
        actions: [
          TextButton(
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPurchaseScreen()),
              )
            },
          )
        ],
        title: Text(
          'CHALLENGES',
          style: kAppBarTextStyle.copyWith(fontSize: 25),
        ),
      ),
      body: Consumer<ChallengeData>(
        builder: (BuildContext context, chData, Widget? child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, ChooseQnt.id),
                      child: Text(
                        'CHALLENGES',
                        style: kAppBarTextStyle,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(onSurface: Colors.black),
                      onPressed: null,
                      child: Text(
                        'MULTI LANG(SOON) ',
                        style: kAppBarTextStyle,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(onSurface: Colors.black),
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
                        'INTRO ',
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
      ),
    );
  }
}
