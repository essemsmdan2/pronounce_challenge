import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen/challenge_screen.dart';
import 'package:pronounce_challenge/screens/results_screen/results_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen/selection_screen.dart';
import 'package:pronounce_challenge/user_preferences.dart';
import 'package:provider/provider.dart';

class ButtonsInRow extends StatefulWidget {
  int challengeQnt;

  ButtonsInRow({Key? key, required this.challengeQnt}) : super(key: key);

  @override
  State<ButtonsInRow> createState() => _ButtonsInRowState();
}

class _ButtonsInRowState extends State<ButtonsInRow> {
  AudioCache audioCache = AudioCache();

  AudioPlayer advancedPlayer = AudioPlayer();

  String? localFilePath;

  String? localAudioCacheURI;
  late RewardedAd rewardedAd;

  void loadRewardAd() {
    RewardedAd.load(
        adUnitId: defaultTargetPlatform == TargetPlatform.android ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
          },
        ));
  }

  void showRewardAd() {
    rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
      // Reward the user for watching an ad.
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadRewardAd();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        //

        return Row(
          children: [
            ElevatedButton(
              onPressed: chData.trys > 0 && !chData.isListening ? () => chData.speak() : null,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.play_arrow,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: chData.trys > 0 && !chData.isListening ? () => chData.speakSlow() : null,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.volume_up_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            /*  const SizedBox(
              width: 10,
            ),
           ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )*/
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (chData.challengeNumber == widget.challengeQnt) {
                  showRewardAd();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultsScreen(
                              contextscreen: ChallengeScreen(
                                challengeQnt: widget.challengeQnt,
                              ),
                            )),
                    ModalRoute.withName("" + SelectionScreen.id),
                  );
                } else {
                  chData.nextRandomText();
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.navigate_next,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
