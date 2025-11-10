import 'dart:math';
import 'package:fhtwzadmin/utils/loading/loading_overlay_pro.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';
import 'utils/classlist.dart';
import 'utils/decoration.dart';

//
bool isLoading = false;
User connectedUser = User.fromMap({});
String nomstructure = 'FORD HIGH TECH';
String adressestructure = 'Cotonou Avenue Stermeitz 303 Rue 089';

//
// Backend & APIs
//
String backendUrl = dotenv.env['BACKEND_API_URL'] ?? "";
String urlapimomo = dotenv.env['MOMO_URL'] ?? "" ;
String cleapimomo = dotenv.env['MOMO_KEY'] ?? "" ;
String urlapifmk = dotenv.env['FMK_URL'] ?? "" ;
String cleapifmk = dotenv.env['FMK_KEY'] ?? "";
double regisFee = 25000;
//
//
// Utils
//
//
double scrW(context) {
  return MediaQuery.of(context).size.width;
}

double scrH(context) {
  return MediaQuery.of(context).size.height;
}

List colslst = [
  Color.fromARGB(255, 233, 104, 61),
  Color.fromARGB(255, 255, 145, 0),
  Color.fromARGB(255, 110, 233, 61),
  Color.fromARGB(255, 61, 233, 78),
  Color.fromARGB(255, 13, 227, 250),
  Color.fromARGB(255, 28, 156, 247),
  Color.fromARGB(255, 78, 61, 233),
  Color.fromARGB(255, 173, 61, 233),
  Color.fromARGB(255, 233, 61, 196),
  Color.fromARGB(255, 233, 61, 61),
];

Color randomColor() {
  return colslst[Random().nextInt(colslst.length)];
}

void ouvrirO(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) => page),
  );
}

void ouvrirR(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (BuildContext context) => page),
  );
}

void fermer(context) {
  Navigator.of(context).pop();
}

rowInfo(key, value, {mainCol}) {
  mainCol ??= primaryColor;
  return Row(
    children: [
      Expanded(
        flex: 0,
        child: Text(key, style: wtTitle(16, 1, mainCol, true, false)),
      ),
      Expanded(
        flex: 1,
        child: Text(value, style: wtTitle(16, 1, Colors.black, true, false)),
      ),
    ],
  );
}

loadingWidget() {
  return LoadingDoubleFlipping.circle(
    backgroundColor: primaryColor,
    borderColor: Colors.white,
    borderSize: 6,
    size: 80,
  );
}

Future customDiag(
  BuildContext context,
  Widget child, {
  bool noPadd = false,
}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: noPadd ? EdgeInsets.all(0) : null,
        insetPadding: noPadd ? EdgeInsets.all(0) : null,
        elevation: 5,
        scrollable: true,
        content: child,
      );
    },
  );
}

customBottomSheetBuildContext(
  context,
  double height,
  Widget child, {
  bool isDismissible = false,
}) {
  showModalBottomSheet(
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return FractionallySizedBox(heightFactor: height, child: child);
    },
  );
}

Widget buildCustomCard({
  required Widget child,
  required Color stripeColor,
  Color bgCol = Colors.white,
  double stripeHeight = 60,
}) {
  final key = GlobalKey();
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

    child: Row(
      children: [
        // Bande colorée à gauche
        Container(
          width: 6,
          height: key.currentContext == null
              ? stripeHeight
              : key.currentContext!.size!.height,
          decoration: BoxDecoration(
            color: stripeColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
        // Le contenu
        Expanded(
          child: Container(
            key: key,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: bgCol,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: child,
          ),
        ),
      ],
    ),
  );
}

showToast(
  BuildContext context,
  String title,
  String content, {
  ToastificationType type = ToastificationType.success,
}) {
  toastification.show(
    context: context, // optional if you use ToastificationWrapper
    type: type,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 4),
    title: Text(title),
    // you can also use RichText widget for title and description parameters
    description: Text(content), // RichText(text: TextSpan(text: content)),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 400),
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    icon: type == ToastificationType.success
        ? Icon(Icons.check_outlined)
        : type == ToastificationType.error
        ? Icon(Icons.error_outline_outlined)
        : Icon(Icons.notifications_active_outlined),
    showIcon: true, // show or hide the icon
    primaryColor: type == ToastificationType.success
        ? Color.fromARGB(255, 83, 238, 101)
        : Color(0xffEE5366),
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: type == ToastificationType.success
          ? Color.fromARGB(255, 83, 238, 101)
          : Color(0xffEE5366),
    ),
    boxShadow: const [
      // BoxShadow(
      //   color: Color(0x07000000),
      //   blurRadius: 16,
      //   offset: Offset(0, 16),
      //   spreadRadius: 0,
      // )
    ],
    showProgressBar: true,
    closeButton: ToastCloseButton(showType: CloseButtonShowType.onHover),
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      onCloseButtonTap: (toastItem) =>
          print('Toast ${toastItem.id} close button tapped'),
      onAutoCompleteCompleted: (toastItem) =>
          print('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
    ),
  );
}

// 8min + 1maj + 1chiff + 1special
RegExp remdp = RegExp(
  r'^(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{6,}$',
);

RegExp passRegex = RegExp(r'^[A-Za-z0-9!@#$%^&*(),.?":{}|<>]{8,}$');

RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

RegExp numeroRegex1 = RegExp(r'^\+(?:[0-9] ?){6,14}[0-9]$');

Widget customButton(
  Color? bgcol,
  Widget child,
  double radius,
  void Function() ontap,
  double padding, {
  opt = 1,
  EdgeInsets cp = const EdgeInsets.all(0),
  double bw = 1,
  bc,
}) {
  bc = bc ?? primaryColor;
  return opt == 1
      ? InkWell(
          onTap: ontap,
          child: Card(
            color: bgcol,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: Container(
              padding: padding < 0 ? cp : EdgeInsets.all(padding),
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
              child: child,
            ),
          ),
        )
      : InkWell(
          onTap: ontap,
          child: Container(
            padding: padding < 0 ? cp : EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: bgcol,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              border: Border.all(width: bw, color: bc),
            ),
            child: child,
          ),
        );
}

Widget customCard(
  Widget childWidget, {
  col = const Color.fromARGB(255, 255, 255, 255),
}) {
  return Card(
    surfaceTintColor: col,
    color: col,
    elevation: 10,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(padding: const EdgeInsets.all(15), child: childWidget),
  );
}

Widget customIcon(
  Color? bcolor,
  Color? fcolor,
  IconData icondata,
  void Function() ontap, {
  double rd = 20,
  double sz = 30,
}) {
  return Container(
    // padding: EdgeInsets.all(pd),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          blurRadius: 0.5,
          offset: Offset(0, 5),
          color: Color.fromARGB(47, 0, 0, 0),
          spreadRadius: 1,
        ),
      ],
      shape: BoxShape.circle,
    ),
    child: InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: rd,
        backgroundColor: bcolor,
        child: Icon(icondata, size: sz, color: fcolor),
      ),
    ),
  );
}

String monnaieformat(String price) {
  String priceIntext = '';
  int counter = 0;
  for (int i = (price.length - 1); i >= 0; i--) {
    counter++;
    String str = price[i];
    if ((counter % 3) != 0 && i != 0) {
      priceIntext = "$str$priceIntext";
    } else if (i == 0) {
      priceIntext = "$str$priceIntext";
    } else {
      priceIntext = " $str$priceIntext";
    }
  }
  return priceIntext.trim();
}

String dateToFrench(DateTime dt) {
  try {
    String jour = dt.day.toString();
    if (int.parse(jour) < 10) {
      jour = "0$jour";
    } else {
      jour = jour;
    }
    String mois = dt.month.toString();
    if (int.parse(mois) < 10) {
      mois = "0$mois";
    } else {
      mois = mois;
    }
    String annee = dt.year.toString();

    return "$jour-$mois-$annee";
  } catch (e) {
    return '';
  }
}

String formatDateCustom(DateTime date, {String lang = 'fr'}) {
  final months = {
    'fr': [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ],
    'en': [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ],
  };

  final monthList = months[lang] ?? months['fr']!;
  final month = monthList[date.month - 1];

  if (lang == 'en') {
    return "${month} ${date.day.toString().padLeft(2, '0')} ${date.year}";
  } else {
    return "${date.day.toString().padLeft(2, '0')} $month ${date.year}";
  }
}

String dateToEnglish(String dt) {
  try {
    String jour = dt.substring(0, 2).toString();
    String mois = dt.substring(3, 5).toString();
    String annee = dt.substring(6, 10).toString();

    return "$annee-$mois-$jour".toString().trim();
  } catch (e) {
    return '';
  }
}
