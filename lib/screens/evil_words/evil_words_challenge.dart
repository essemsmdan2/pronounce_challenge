import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pronounce_challenge/constants.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen/floating_microphone.dart';
import 'package:pronounce_challenge/screens/results_screen/results_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen/selection_screen.dart';
import 'package:pronounce_challenge/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'evil_words_buttonsRow.dart';

class EvilWordsScreen extends StatefulWidget {
  static String id = "EvilWords Screen";

  const EvilWordsScreen({Key? key}) : super(key: key);

  @override
  State<EvilWordsScreen> createState() => _EvilWordsScreen();
}

class _EvilWordsScreen extends State<EvilWordsScreen> {
  int _indexCount = 0;
  String appBarInfo(List array) {
    return "${array.length}/${_indexCount + 1}";
  }

  late RewardedAd rewardedAd;
  void loadRewardAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
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
    loadRewardAd();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChallengeData>(context, listen: false).setevilWordIndexText(_indexCount);
      Provider.of<ChallengeData>(context, listen: false).resetWorldConts();
      print(Provider.of<ChallengeData>(context, listen: false).evilWordArray);
      Provider.of<ChallengeData>(context, listen: false).resetPoints();
      Provider.of<ChallengeData>(context, listen: false).resetTrys();
      Provider.of<ChallengeData>(context, listen: false).setresultColor(kPrimaryColor);
      Provider.of<ChallengeData>(context, listen: false).changeTextInput("Press the button and start Speaking");
    });
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'PRACTICE',
                    textAlign: TextAlign.center,
                    style: kAppBarTextStyle.copyWith(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${appBarInfo(chData.evilWordArray)} ',
                    textAlign: TextAlign.center,
                    style: kAppBarTextStyle.copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingMicrophoneInput(
              screenContext: EvilWordsScreen.id,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Card(
                              elevation: 10,
                              color: chData.resultColor,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    chData.textInput,
                                    style: kPrimaryTextStyle.copyWith(fontSize: 25),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )),
                        ),
                        Card(
                          elevation: 10,
                          color: kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${chData.points}",
                                  style: kPrimaryTextStyle,
                                ),
                                Text(
                                  'Points',
                                  style: kSecondaryTextStyle,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 1, left: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chData.evilWordArray[_indexCount],
                                style: kBigTextStyle,
                              ),
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Card(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                  elevation: 10,
                                  color: kPrimaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${chData.trys}",
                                          style: kSecondaryTextStyle,
                                        ),
                                        Text(
                                          'Trys',
                                          style: kSecondaryTextStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
/*                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "${chData.printResult(chData.nysiisModified, chData.randomText)}",
                            style: kBiglittleTextStyle,
                          ),
                        )*/
                        const SizedBox(height: 90),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5.2),
                          child: ButtonsInRowEvil(
                            callback2: () {
                              if (chData.evilWordArray.length > 1) {
                                chData.removeEvilWordInIndex(_indexCount);
                                UserPreferences.setEvilWords(chData.evilWordArray);
                              } else {
                                Navigator.pop(context);
                                chData.setShowEvilWordMenu(false);
                                print(chData.showEvilWordsMenu);

                                Timer(Duration(seconds: 1), () {
                                  chData.resetEvilWordArrayOneUseOnly();

                                  UserPreferences.setEvilWords(chData.evilWordArray);
                                  print('removed');
                                });
                              }
                            },
                            callback: () {
                              chData.changeTextInput(chData.pressText);
                              chData.setresultColor(kPrimaryColor);
                              if (_indexCount + 1 >= chData.evilWordArray.length) {
                                showRewardAd();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultsScreen(
                                            contextscreen: const EvilWordsScreen(),
                                          )),
                                  ModalRoute.withName("" + SelectionScreen.id),
                                );
                              } else {
                                setState(() {
                                  _indexCount++;
                                  chData.setevilWordIndexText(_indexCount);
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                WaveWidget(
                    waveFrequency: 3,
                    config: CustomConfig(
                      gradients: [
                        [Colors.red, Colors.pinkAccent],
                        [Colors.redAccent, Colors.pinkAccent],
                        [Colors.orange, Colors.yellowAccent],
                        [Colors.yellowAccent, Colors.red],
                      ],
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                      durations: [35000, 19440, 10800, 6000],
                      heightPercentages: chData.isListening ? [0.20, 0.23, 0.25, 0.3] : [10, 10, 10, 10],
                      blur: const MaskFilter.blur(BlurStyle.outer, 10),
                    ),
                    waveAmplitude: 0,
                    heightPercentange: 0.2,
                    size: const Size(double.infinity, 50)),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: AdWidget(ad: myBanner),
                )
              ],
            ));
      },
    );
  }
}
