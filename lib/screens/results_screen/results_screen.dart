import 'package:flutter/material.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen/challenge_screen.dart';
import 'package:pronounce_challenge/screens/details_screen/detail_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen/selection_screen.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ResultsScreen extends StatelessWidget {
  static String id = "Results Screen";

  var contextscreen;

  ResultsScreen({Key? key, this.contextscreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        String resultGrade() {
          String result = "";
          if (chData.points >= 18) {
            result = "images/A.png";
          } else if (chData.points >= 14) {
            result = "images/B.png";
          } else if (chData.points >= 10) {
            result = "images/C.png";
          } else if (chData.points >= 6) {
            result = "images/D.png";
          } else {
            result = "images/F.png";
          }

          return result;
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            centerTitle: true,
            title: Text(
              'RESULT',
              style: kAppBarTextStyle.copyWith(fontSize: 25),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    'RESULT:',
                    style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Card(
                        elevation: 10,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      '${chData.points}',
                      textAlign: TextAlign.center,
                      style: kBigTextStyle.copyWith(fontSize: 50, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 13,
                      right: 13,
                      child: Image.asset(
                        resultGrade(),
                        width: 100,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${chData.firstTry} FIRST TRY',
                          style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                        ),
                        Text(
                          '${chData.secondTry} SECOND TRY',
                          style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                        ),
                        Text(
                          '${chData.lastTry} LAST TRY',
                          style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                        ),
                        Text(
                          '${chData.evilWordsCount} EVIL WORDSS',
                          style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, DetailScreen.id);
                              },
                              child: Text(
                                "Details",
                                style: kAppBarTextStyle.copyWith(fontSize: 20, letterSpacing: 2, color: kSecondaryColorStyle),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          chData.resetWorldConts();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    contextscreen ??
                                    ChallengeScreen(
                                      challengeQnt: 10,
                                    )),
                            ModalRoute.withName("" + SelectionScreen.id),
                          );
                        },
                        child: Text(
                          'RESTART',
                          style: kAppBarTextStyle,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SelectionScreen.id);
                        },
                        child: Text(
                          'MENU',
                          style: kAppBarTextStyle,
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
