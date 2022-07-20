import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pronounce_challenge/api/firebase_notifications.dart';
import 'package:pronounce_challenge/modals/challenge_data.dart';
import 'package:pronounce_challenge/modals/user_preferences.dart';
import 'package:pronounce_challenge/screens/challenge_screen.dart';
import 'package:pronounce_challenge/screens/choose_qnt_screen.dart';
import 'package:pronounce_challenge/screens/detail_screen.dart';
import 'package:pronounce_challenge/screens/evil_words_screen.dart';
import 'package:pronounce_challenge/screens/onboarding_screen.dart';
import 'package:pronounce_challenge/screens/results_screen.dart';
import 'package:pronounce_challenge/screens/selection_screen.dart';
import 'package:pronounce_challenge/widget/new_floating_microphone.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'modals/constants.dart';

const List<String> testDeviceIds = ['E60E971E50CC81F9C40D9A05AAE53E0C'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDeviceIds);
  MobileAds.instance.updateRequestConfiguration(configuration);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FireBaseNotificationsApi.requestandoPermissiones();
  FirebaseMessaging.onBackgroundMessage(
      FireBaseNotificationsApi.firebaseMessagingBackgroundHandler);

  //linhas abaixo usadas para identificar o token do celular de teste pra uso no console do firebase
  print(await FireBaseNotificationsApi.fcmToken);
  print('esse de cima ai');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await UserPreferences.init();
  runApp(PronounceChallenge());
}

class PronounceChallenge extends StatefulWidget {
  @override
  State<PronounceChallenge> createState() => _PronounceChallengeState();
}

class _PronounceChallengeState extends State<PronounceChallenge> {
  bool? _firstTime;

  @override
  void initState() {
    // TODO: implement initState
    _firstTime = UserPreferences.getFirstTimeBool() ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ChallengeData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: kPrimaryColor,
            )),
        initialRoute:
            _firstTime ?? true ? OnBoardingPage.id : SelectionScreen.id,
        routes: {
          DetailScreen.id: (context) => const DetailScreen(),
          ChallengeScreen.id: (context) => ChallengeScreen(
                challengeQnt: 10,
              ),
          ResultsScreen.id: (context) => ResultsScreen(),
          SelectionScreen.id: (context) => const SelectionScreen(),
          OnBoardingPage.id: (context) => OnBoardingPage(),
          ChooseQnt.id: (context) => ChooseQnt(),
          EvilWordsScreen.id: (context) => const EvilWordsScreen(),
          NewfloatingMic.id: (context) => NewfloatingMic(
                screenContext: ChallengeScreen.id,
              ),
        },
      ),
    );
  }
}
