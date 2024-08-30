import 'package:flutter/material.dart';

class Constants {
  static const String pdfAsset = "assets/dart_flutter.pdf";
  static const String dictionaryAsset = "assets/eng_dictionary.db";
  static const Duration globalDuration = Duration(milliseconds: 1000);
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
