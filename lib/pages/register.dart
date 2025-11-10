import 'dart:async';

import 'package:fhtwzadmin/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../utils/decoration.dart';
import '../utils/loading/src/loading_overlay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController adressCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController confassCtrl = TextEditingController();

  TextEditingController mttCtrl = TextEditingController();
  TextEditingController numctrl = TextEditingController();

  bool showpass = true, showpass2 = true;

  final formkey = GlobalKey<FormState>();
  final formkeypay = GlobalKey<FormState>();

  List<Map> reseauxLst = [
    {'id': 0, 'nom': 'MTN', 'img': 'assets/images/mtn2.png'},
    {'id': 1, 'nom': 'MOOV', 'img': 'assets/images/moov.png'},
    {'id': 2, 'nom': 'CELTIIS', 'img': 'assets/images/sbin.png'},
  ];

  int oprchoix = 0;

  List<Map> codeReseauxLst = [];

  Future data() async {
    setState(() {
      isLoading = true;
    });
    //
    await fetchReseauxCodes(context);
    //
    //
    setState(() {
      isLoading = false;
    });
  }

  fetchReseauxCodes(BuildContext context) async {
    var url2 = Uri.parse('$urlapifmk/codes_resaux');
    try {
      var response = await http.get(url2, headers: {"apikey": cleapifmk});
      var lst1 = jsonDecode(response.body);
      // print("Liste Reseaux : $lst1");
      if (response.statusCode == 200) {
        codeReseauxLst.clear();
        for (var i = 0; i < lst1.length; i++) {
          codeReseauxLst.add({
            "code": lst1[i]['code'].toString(),
            "idR": lst1[i]['id_r'].toString(),
          });
        }
      } else {
        showToast(
          context,
          "Erreur Serveur !",
          lst1,
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      showToast(
        context,
        "Erreur Serveur !",
        'Codes reseux   -${e.toString()}',
        type: ToastificationType.error,
      );
    }
  }

  Future<String> fmomo(
    BuildContext context,
    String idproject,
    String numero,
    String montant,
    String numeropaiement,
    String message,
    String note,
  ) async {
    String result = '';
    var url2 = Uri.parse('$urlapimomo/momopay/requesttopay');
    try {
      var fromdata = {
        "id_projet": idproject,
        "numero_user": numero,
        "montant": montant,
        "numero": numeropaiement,
        "message": message,
        "note": note,
        "vuuid": '',
        "externalId": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      var response = await http.post(
        url2,
        body: fromdata,
        headers: {"apikey": cleapimomo, "Access-Control-Allow-Origin": "*"},
      );
      var lst0 = jsonDecode(response.body);
      print("Payement request body : $fromdata ----- request response : $lst0");
      if (response.statusCode == 200) {
        result = lst0['status'];
      } else {
        result = 'bad';
        showToast(
          context,
          "Erreur Serveur !",
          lst0,
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      result = 'bad';
      showToast(
        context,
        "Erreur Serveur !",
        '-PAIEMENT MOMO-${e.toString()}',
        type: ToastificationType.error,
      );
    }
    return result;
  }

  registerUser() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {
          'vartraitement': '2',
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'nom': nameCtrl.text,
          'adress': adressCtrl.text,
          'phone': phoneCtrl.text,
          'pass': passCtrl.text,
        },
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        customDiag(context, succespay());
      } else {
        showToast(
          context,
          "Erreur Serveur !",
          lst['message'],
          type: ToastificationType.error,
        );
      }
    } catch (e) {
      print(e);
      showToast(
        context,
        "Erreur de Connexion !",
        e.toString(),
        type: ToastificationType.error,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  processPayment() async {
    setState(() {
      isLoading = true;
    });
    String result = await fmomo(
      context,
      '6',
      phoneCtrl.text.replaceAll(" ", ''),
      mttCtrl.text,
      '229${numctrl.text.replaceAll(" ", '')}',
      "Vous procédez à paiement de ${mttCtrl.text} FCFA pour frais d'adhésion FHTWZ",
      "FHTWZ INSCRIPTION",
    );
    print("Result Payment : $result");

    // fermer(context);
    // await registerUser();

    if (result == 'SUCCESSFUL') {
      await registerUser();
    } else {
      fermer(context);
      customDiag(context, echecpay());
    }

    setState(() {
      isLoading = false;
    });
  }

  void _ouvrirDialogPaiement() {
    setState(() {
      oprchoix = 0;
      mttCtrl.text = regisFee.toString();
      numctrl.text = "";
    });
    // showModalBottomSheet(
    //   shape: const RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
    //   ),
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.white,
    //   context: context,
    //   builder: (context) {
    //     return contenuPayement();
    //   },
    // );
    customDiag(context, contenuPayement());
  }

  @override
  void initState() {
    super.initState();
    data();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: loadingWidget(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: FB5Row(
            classNames: 'justify-content-center',
            children: [
              FB5Col(
                classNames: 'col-10 col-md-7 col-lg-5',
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Inscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: secondaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 160),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: secondaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),

                    Container(
                      constraints: BoxConstraints(
                        maxHeight: 230,
                        maxWidth: 230,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameCtrl,
                              keyboardType: TextInputType.text,
                              decoration: mydecoration(
                                'Nom *',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.business,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                false,
                                SizedBox(),
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Ce champ est Obligatoire";
                                }
                                return null;
                              },
                            ),
                            //
                            SizedBox(height: 20),

                            TextFormField(
                              controller: adressCtrl,
                              keyboardType: TextInputType.text,
                              decoration: mydecoration(
                                'Adresse *',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                false,
                                SizedBox(),
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Ce champ est Obligatoire";
                                }
                                return null;
                              },
                            ),
                            //
                            SizedBox(height: 20),

                            TextFormField(
                              controller: phoneCtrl,
                              keyboardType: TextInputType.text,
                              decoration: mydecoration(
                                'Téléphone *',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.phone,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                false,
                                SizedBox(),
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Ce champ est Obligatoire";
                                }
                                return null;
                              },
                            ),
                            //
                            SizedBox(height: 20),

                            //
                            TextFormField(
                              controller: passCtrl,
                              keyboardType: TextInputType.text,
                              obscureText: showpass,
                              decoration: mydecoration(
                                'Mot de Passe *',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                true,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showpass = !showpass;
                                    });
                                  },
                                  icon: Icon(
                                    showpass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Ce champ est Obligatoire";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            TextFormField(
                              controller: confassCtrl,
                              keyboardType: TextInputType.text,
                              obscureText: showpass2,
                              decoration: mydecoration(
                                'Confirmer *',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        child: VerticalDivider(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                true,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showpass2 = !showpass2;
                                    });
                                  },
                                  icon: Icon(
                                    showpass2
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                BorderRadius.all(Radius.circular(30)),
                              ),
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Ce champ est Obligatoire";
                                } else if (value.isNotEmpty &&
                                    value.toString() != passCtrl.text) {
                                  return "Mot de passe Incorrect !";
                                }
                                return null;
                              },
                            ),

                            //
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        runSpacing: 5,
                        runAlignment: WrapAlignment.center,
                        children: [
                          Text(
                            "Vous avez déjà un compte ?",
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          InkWell(
                            onTap: () {
                              ouvrirR(context, LoginPage());
                            },
                            child: Text(
                              "Connectez-vous",
                              style: wtTitle(14, 1, Colors.black, true, false),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    customButton(
                      primaryColor,
                      Text(
                        'S\'inscrire pour ${regisFee.toString()} FCFA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      22,
                      () async {
                        if (formkey.currentState!.validate()) {
                          _ouvrirDialogPaiement();
                        }
                      },
                      -15,
                      cp: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                    SizedBox(height: 50),

                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "@ Ford Wifi Zone",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contenuPayement() {
    return Form(
      key: formkeypay,
      child: Column(
        children: [

          // Close
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    fermer(context);
                    //
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Icon(Icons.close, color: primaryColor),
                  ),
                ),
              ],
            ),
          //
          // Title
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Effectuer le Paiement',
              style: wtTitle(20, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          //
          SizedBox(height: 10),
          // Montant
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: mttCtrl,
              enabled: false,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return "Veuillez entrer un montant";
                }
                final montant = int.tryParse(val);
                if (montant == null) return "Montant invalide";
                if (montant <= 0) {
                  return "Le montant doit être positif";
                }
                if (montant > regisFee) {
                  return "Montant trop élevé (reste: $regisFee)";
                }
                return null;
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: wtTitle(18.0, 1, null, false, false),
              decoration: mydecoration(
                "Montant à Payer",
                10,
                15,
                true,
                const Icon(Icons.monetization_on_outlined),
                false,
                SizedBox(),
                BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          //
          SizedBox(height: 10),
          // Opérateurs
          Column(
            children: [
              Text(
                'Payer Avec',
                style: wtTitle(15, 1, Colors.black, true, false),
              ),
              SizedBox(height: 10),
              Text(
                reseauxLst.firstWhere(
                  (element) => element['id'] == oprchoix,
                )['nom'],
                style: wtTitle(12, 1, Colors.black, true, false),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: reseauxLst
                        .map(
                          (e) =>
                              //
                              // Réseau
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: InkWell(
                                  onTap: () {
                                    //
                                    setState(() {
                                      oprchoix = e['id'];
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: oprchoix == e['id']
                                        ? BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 3,
                                              color: Colors.green,
                                            ),
                                          )
                                        : BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 3,
                                              color: const Color.fromARGB(
                                                42,
                                                76,
                                                175,
                                                79,
                                              ),
                                            ),
                                          ),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(e['img']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          //
          SizedBox(height: 10),
          //
          // Num
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              controller: numctrl,
              onChanged: (value) {
                if (value.length >= 2 &&
                    codeReseauxLst
                        .where((e) => e['code'] == value.substring(0, 2))
                        .isNotEmpty) {
                  setState(() {
                    oprchoix = int.parse(
                      codeReseauxLst.firstWhere(
                        (e) => e['code'] == value.substring(0, 2),
                      )['idR'],
                    );
                  });
                }
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Saisissez un Numero';
                } else if (value.length >= 2 &&
                    codeReseauxLst
                        .where((e) => e['code'] == value.substring(0, 2))
                        .isEmpty) {
                  return 'Réseau Inconnu !';
                } else if (oprchoix != 0) {
                  return 'Seul MTN est déjà disponible !';
                }
                return null;
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              // inputFormatters: [FormatTelph()],
              // style: styleZoneSaisie(18.0, 3.0),
              decoration: mydecoration(
                "Numéro",
                10,
                10,
                true,
                // const Icon(Icons.phone),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        "+229 01",
                        style: wtTitle(
                          14,
                          1,
                          Color.fromARGB(125, 44, 44, 44),
                          true,
                          false,
                        ),
                      ),
                    ),
                  ],
                ),
                false,
                SizedBox(),
                BorderRadius.circular(15),
              ),
            ),
          ),
          //
          // Boutons
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  //
                  if (formkeypay.currentState!.validate()) {
                    // Lancer Payement
                    await processPayment();
                  }
                },
                icon: const Icon(Icons.payment, color: Colors.white),
                label: const Text(
                  "Payer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //
  Widget succespay() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            //
            // Close
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    fermer(context);
                    ouvrirR(context, LoginPage());

                    //
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Icon(Icons.close, color: primaryColor),
                  ),
                ),
              ],
            ),
            //
            // Title
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Payement Effectué',
                style: wtTitle(20, 1, Colors.black, true, false),
                textAlign: TextAlign.center,
              ),
            ),
            //
            //
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromARGB(137, 139, 195, 74),
                  width: 8,
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_outlined,
                color: Colors.green,
                size: 200,
              ),
            ),
            //
            // Textes
            //
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Le payement a été effectué avec succès ',
                style: wtTitle(16, 1, Colors.black, false, false),
                textAlign: TextAlign.center,
              ),
            ),
            //
            // Boutons
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    //
                    fermer(context);
                    ouvrirR(context, LoginPage());
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    "Continuer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //
              ],
            ),
          ],
        );
      },
    );
  }

  Widget echecpay() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            //
            // Close
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    fermer(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor),
                    ),
                    child: Icon(Icons.close, color: primaryColor),
                  ),
                ),
              ],
            ),
            //
            // Title
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Payement Non Effectué',
                style: wtTitle(20, 1, Colors.black, true, false),
                textAlign: TextAlign.center,
              ),
            ),
            //
            //
            Container(
              padding: EdgeInsets.all(2),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color.fromARGB(136, 195, 74, 74),
                  width: 8,
                ),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: Colors.redAccent,
                size: 200,
              ),
            ),
            //
            // Textes
            //
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Le Payement n\'a pas pu être effectué. Veuillez vérifier votre solde et Réessayer !',
                style: wtTitle(16, 1, Colors.black, false, false),
                textAlign: TextAlign.center,
              ),
            ),
            //
            //
            // Boutons
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    //
                    fermer(context);
                    await processPayment();
                  },
                  icon: const Icon(Icons.refresh_outlined, color: Colors.white),
                  label: const Text(
                    "Relancer",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
