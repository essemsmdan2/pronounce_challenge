import 'package:flutter/material.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../modals/constants.dart';
import '../widget/floating_microphone.dart';

class ChallengeScreen extends StatefulWidget {
  static String id = "Challenge Screen";
  late int challengeQnt;

  ChallengeScreen({Key? key, required this.challengeQnt}) : super(key: key);

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ChallengeData>(context, listen: false).nextRandomText();

      Provider.of<ChallengeData>(context, listen: false).resetPoints();
      Provider.of<ChallengeData>(context, listen: false).admob!.addAds(true, true, true);
      Provider.of<ChallengeData>(context, listen: false).resetChallengeNumber();
      Provider.of<ChallengeData>(context, listen: false).resetTrys();
      Provider.of<ChallengeData>(context, listen: false).resetWorldConts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        chData.challengeQnt = widget.challengeQnt;

        return Scaffold(
            appBar: AppBar(
              toolbarHeight: 100,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    '${widget.challengeQnt}/${chData.challengeNumber} ',
                    textAlign: TextAlign.center,
                    style: kAppBarTextStyle.copyWith(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LinearProgressIndicator(
                    minHeight: 10,
                    value: chData.challengeNumber / widget.challengeQnt,
                    color: Colors.lightGreenAccent,
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: 15,
                )
              ],
            ),
            floatingActionButton: FloatingMicrophoneInput(
              screenContext: ChallengeScreen.id,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: Column(
              children: [
                Expanded(
                  child: Column(
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
                                      chData.randomText,
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
                              const SizedBox(height: 5),
                              Row(
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
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: chData.isListening == false ? () => chData.showAdstuff(context) : null,
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
                    ],
                  ),
                ),
                chData.admob.showBannerWidget(context)
              ],
            ));
      },
    );
  }
}
