import 'package:flutter/material.dart';

Color primaryColor = const Color.fromARGB(255, 37, 71, 129);
Color secondaryColor = const Color.fromARGB(115, 233, 21, 77);
Color secondaryColor2 = const Color.fromARGB(29, 129, 37, 62);
Color secondaryColor3 = const Color.fromARGB(10, 129, 37, 62);

OutlineInputBorder myenabledborder(BorderRadius radius, Color col2) {
  return OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: col2, width: 1.8),
  );
}

OutlineInputBorder myfocusborder(BorderRadius radius, Color col) {
  return OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: col, width: 1.8),
  );
}

OutlineInputBorder myerrorborder(BorderRadius radius) {
  return OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: Colors.redAccent, width: 1.8),
  );
}

InputDecoration mydecoration(
  String labeltext,
  double tailleLabelText,
  double tailleLabelTextfloting,
  bool afficherpre,
  Widget prefixe,
  bool affichersuf,
  Widget suffixe,
  BorderRadius radius, {
  col,
  col2,
}) {
  col = primaryColor;
  col2 = secondaryColor;
  return InputDecoration(
    labelText: labeltext,
    labelStyle: wtTitle(tailleLabelText, 1, col, true, false),
    floatingLabelStyle: wtTitle(tailleLabelTextfloting, 1, col, true, false),
    // labelStyle: GoogleFonts.robotoSerif(
    //     color: const Color.fromARGB(133, 110, 110, 110),
    //     fontSize: tailleLabelText,
    //     fontWeight: FontWeight.bold),
    // floatingLabelStyle: GoogleFonts.robotoSerif(
    //     color: const Color.fromARGB(200, 110, 110, 110),
    //     fontSize: tailleLabelTextfloting,
    //     fontWeight: FontWeight.bold),
    enabledBorder: myenabledborder(radius, col2),
    disabledBorder: myenabledborder(radius, col2),
    focusedBorder: myfocusborder(radius, col),
    errorBorder: myerrorborder(radius),
    // focusColor: theme.secondaryColor2,
    focusedErrorBorder: myerrorborder(radius),
    prefixIcon: afficherpre == true ? prefixe : null,
    suffixIcon: affichersuf == true ? suffixe : null,
  );
}

TextStyle wtTitle(
  double size,
  double wspacing,
  Color? color,
  bool bold,
  bool italic,
) => TextStyle(
  fontSize: size,
  wordSpacing: wspacing,
  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
  color: color,
);
