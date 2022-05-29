import 'package:flutter/material.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ScreenShootableResult extends StatelessWidget {
  ScreenShootableResult({
    Key? key,
    required this.chData,
  }) : super(key: key);
  var chData;
  @override
  Widget build(BuildContext context) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'RESULT:',
            textAlign: TextAlign.left,
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
          padding: const EdgeInsets.only(left: 20, top: 20),
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
                  '${chData.evilWordsCount} EVIL WORDS',
                  style: kAppBarTextStyle.copyWith(fontSize: 22, letterSpacing: 2, color: kSecondaryColorStyle),
                ),
                const SizedBox(
                  height: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
