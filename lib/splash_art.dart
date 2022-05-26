import 'package:flutter/material.dart';

class RouteSplash extends StatefulWidget {
  @override
  _RouteSplashState createState() => _RouteSplashState();
}

class _RouteSplashState extends State<RouteSplash> {
  bool shouldProceed = false;

  _fetchPrefs() async {
    await Future.delayed(const Duration(seconds: 1)); // dummy code showing the wait period while getting the preferences
    setState(() {
      shouldProceed = true; //got the prefs; set to some value if needed
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPrefs(); //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: shouldProceed
            ? RaisedButton(
                onPressed: () {
                  //move to next screen and pass the prefs if you want
                },
                child: const Text("Continue"),
              )
            : const CircularProgressIndicator(), //show splash screen here instead of progress indicator
      ),
    );
  }
}
