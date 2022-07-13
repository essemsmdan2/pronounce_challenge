import 'package:flutter/material.dart';

MaterialColor kPrimaryColor = Colors.indigo;
Color kSecondaryColorStyle = kPrimaryColor.shade800;
TextStyle kPrimaryTextStyle = const TextStyle(color: Colors.white, fontSize: 30);
TextStyle kBigTextStyle = const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
TextStyle kBiglittleTextStyle = const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500);
TextStyle kSecondaryTextStyle = const TextStyle(color: Colors.white, fontSize: 20);
TextStyle kAppBarTextStyle = kPrimaryTextStyle.copyWith(fontSize: 20, letterSpacing: 5, fontWeight: FontWeight.bold);
TextStyle kButtonTextStyle = kPrimaryTextStyle.copyWith(fontSize: 15, letterSpacing: 5, fontWeight: FontWeight.bold);
