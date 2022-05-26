import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen/selection_screen.dart';
import 'package:pronounce_challenge/user_preferences.dart';
import 'package:pronounce_challenge/widget/button_widget.dart';

class OnBoardingPage extends StatelessWidget {
  static String id = "onBoardingPage";
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'A reader lives a thousand lives',
              body: 'The man who never reads lives only one.',
              image: buildImage('assets/ebook.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Featured Books',
              body: 'Available right at your fingerprints',
              image: buildImage('assets/readingbook.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Simple UI',
              body: 'For enhanced reading experience',
              image: buildImage('assets/manthumbs.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Today a reader, tomorrow a leader',
              body: 'Start your journey',
              footer: ButtonWidget(
                text: 'Start Reading',
                onClicked: () => goToHome(context),
              ),
              image: buildImage('assets/learn.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done: const Text('Read', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onSkip: () => goToHome(context),
          next: const Icon(
            Icons.arrow_forward,
            size: 27,
          ),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          globalBackgroundColor: Colors.white,
          //skipFlex: 0,
          //nextFlex: 1,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) {
    UserPreferences.setFirstTime();
    print('setado');

    Navigator.pushNamed(context, SelectionScreen.id);
  }

  Widget buildImage(String path) => Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: const Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        //descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(24),
        pageColor: Colors.white,
      );
}
