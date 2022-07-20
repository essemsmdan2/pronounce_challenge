import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modals/challenge_data.dart';

class NewfloatingMic extends StatefulWidget {
  static String id = "newfloatingmic";

  var screenContext;

  NewfloatingMic({Key? key, this.screenContext}) : super(key: key);

  @override
  _NewFloatingMic createState() => _NewFloatingMic();
}

class _NewFloatingMic extends State<NewfloatingMic> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: FloatingActionButton(
        onPressed: () => {
          // If not yet listening for speech start, otherwise stop
          Provider.of<ChallengeData>(context, listen: false)
                  .speechToText
                  .isNotListening
              ? Provider.of<ChallengeData>(context, listen: false)
                  .startListening(context)
              : null
        },
        tooltip: 'Listen',
        child: Provider.of<ChallengeData>(context, listen: true).iconHandler(),
      ),
    );
  }
}
