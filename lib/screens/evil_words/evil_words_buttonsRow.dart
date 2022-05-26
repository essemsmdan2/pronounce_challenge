import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:provider/provider.dart';

class ButtonsInRowEvil extends StatefulWidget {
  var callback;

  var callback2;

  ButtonsInRowEvil({Key? key, required this.callback, required this.callback2}) : super(key: key);

  @override
  State<ButtonsInRowEvil> createState() => _ButtonsInRowEvilState();
}

class _ButtonsInRowEvilState extends State<ButtonsInRowEvil> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  String? localFilePath;
  String? localAudioCacheURI;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeData>(
      builder: (BuildContext context, chData, Widget? child) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: chData.trys > 0 && !chData.isListening ? () => chData.speakEvil() : null,
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
              onPressed: chData.trys > 0 && !chData.isListening ? () => chData.speakSlowEvil() : null,
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
              onPressed: widget.callback,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.navigate_next,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: widget.callback2,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.remove,
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
