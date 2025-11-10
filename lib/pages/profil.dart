import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../pages/login.dart';
import '../utils/decoration.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController actpassCtrl = TextEditingController();
  TextEditingController newpassCtrl = TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool showpass = true, showpass2 = true;

  updatePass() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {
          'vartraitement': '3',
          'id': connectedUser.pseudo,
          'pass': newpassCtrl.text,
        },
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        setState(() {
          connectedUser.mot = newpassCtrl.text;
          actpassCtrl.text = "";
          newpassCtrl.text = "";
        });
        showToast(context, "Mot de Passe Mis à Jour !", "A l'instant");
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
        "Erreur de Mise à Jour !",
        e.toString(),
        type: ToastificationType.error,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: loadingWidget(),
      child: Scaffold(
        backgroundColor: secondaryColor3,
        body: SingleChildScrollView(
          child: FB5Row(
            classNames: 'justify-content-center',
            children: [
              FB5Col(
                classNames: 'col-10 col-md-7 col-lg-5',
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Mon Compte",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primaryColor, fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 130),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 160),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Personal Infos
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Informations Personnelles",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: secondaryColor2,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: Column(
                        children: [
                          rowInfo("Nom : ", connectedUser.nom),
                          rowInfo("Adresse : ", connectedUser.libptvente),
                          rowInfo("Téléphone : ", connectedUser.prenom),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),
                    // Password Update
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Mot de Passe",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                            InkWell(
                              onTap: () async {
                                if (formkey.currentState!.validate()) {
                                  updatePass();
                                }
                              },
                              child: Text(
                                "Valider",
                                style: wtTitle(
                                  16,
                                  1,
                                  primaryColor,
                                  true,
                                  false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //
                    Container(
                      decoration: BoxDecoration(
                        color: secondaryColor2,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: actpassCtrl,
                              keyboardType: TextInputType.text,
                              obscureText: showpass,
                              decoration: mydecoration(
                                'Password Actuel',
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
                                  return "Obligatoire";
                                } else if (value != connectedUser.mot) {
                                  return "Mot de Passe Incorrect";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 15),
                            //
                            TextFormField(
                              controller: newpassCtrl,
                              keyboardType: TextInputType.text,
                              obscureText: showpass2,
                              decoration: mydecoration(
                                'Nouveau Password',
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
                                  return "Obligatoire";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                        vertical: 15,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: customButton(
                        const Color.fromARGB(210, 244, 67, 54),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Déconnexion',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        22,
                        () async {
                          ouvrirR(context, LoginPage());
                        },
                        -15,
                        cp: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
