// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SnackBar createSnackBar(BuildContext context, MaterialColor background,
    String message, Function callback) {
  return SnackBar(
    content: Text(
      message,
      style: GoogleFonts.dmSans(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        textStyle: Theme.of(context).textTheme.button,
      ),
    ),
    backgroundColor: background,
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {
        callback();
      },
      textColor: Colors.white,
    ),
  );
}

///SHOW MESSAGE
void showMessage(
    BuildContext context, MaterialColor background, String message) {
  var snackBar = createSnackBar(context, background, message, () {});
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
