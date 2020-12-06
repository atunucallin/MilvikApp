import 'dart:ui';

import 'package:flutter/material.dart';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);
final appBackground = Color(0xffF3F2F8);
final kColorGreyShade200 = Colors.grey.shade200;

final Color kBackGroundGreyColor = Colors.grey.shade200;

const kSendButtonTextStyle = TextStyle(
  color: Colors.deepPurpleAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

final TextStyle kLargeCaptionLabelTextStyle = TextStyle(
  fontSize: 50,
  backgroundColor: kBackGroundGreyColor,
  fontWeight: FontWeight.bold,
);

const TextStyle kAppleActionButtonTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blue,
);
