import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen/challenge_screen.dart';
import 'package:pronounce_challenge/screens/results_screen/results_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen/selection_screen.dart';

import 'package:provider/provider.dart';

import '../../widget/admob_manager.dart';

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
  AdManager adManager = AdManager();

  @override
  void initState() {
    super.initState();
    adManager.addAds(false, false, true);
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
                  try {
                    adManager.showRewardedAd();
                  } catch (e) {
                    print("this is the error i'm looking for $e");
                  }

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
