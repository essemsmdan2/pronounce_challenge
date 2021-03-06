import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/screens/challenge_screen.dart';
import 'package:pronounce_challenge/screens/detail_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../api/admob_manager.dart';
import '../modals/constants.dart';
import '../modals/screen_shootable_result.dart';

class ResultsScreen extends StatefulWidget {
  static String id = "Results Screen";

  var contextscreen;

  ResultsScreen({Key? key, this.contextscreen}) : super(key: key);

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  AdManager admob = AdManager();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    admob.addAds(false, true, false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        return Screenshot(
          controller: screenshotController,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: Platform.isIOS ? kToolbarHeight : 100,
              centerTitle: true,
              title: Text(
                'RESULT',
                style: kAppBarTextStyle.copyWith(fontSize: 25),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ScreenShootableResult(
                    chData: chData,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
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
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(5)),
                            ),
                            onPressed: () {
                              chData.resetWorldConts();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        widget.contextscreen ??
                                        ChallengeScreen(
                                          challengeQnt: 10,
                                        )),
                                ModalRoute.withName("" + SelectionScreen.id),
                              );
                            },
                            child: Text(
                              'RESTART',
                              style: kButtonTextStyle,
                            )),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => SelectionScreen()),
                                ModalRoute.withName(""),
                              );
                            },
                            child: Text(
                              'MENU',
                              style: kButtonTextStyle,
                            )),
                        ElevatedButton(
                            onPressed: () async {
                              final image = await screenshotController.capture();

                              if (image == null) return;
                              saveAndShare(image);
                            },
                            child: Text(
                              'SHARE',
                              style: kButtonTextStyle,
                            )),
                      ],
                    ),
                  ),
                  admob.showBannerWidget(context)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Future saveAndShare(Uint8List bytes) async {
  await [Permission.storage].request();
  final directory = await getApplicationDocumentsDirectory();
  final image = File("${directory.path}/flutter.png");
  image.writeAsBytesSync(bytes);

  final text = "Hey! Check out my results !";
  await Share.shareFiles([image.path], text: text);
}
