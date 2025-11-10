import 'package:fhtwzadmin/pages/register.dart';
import 'package:fhtwzadmin/pages/sidebarMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../utils/classlist.dart';
import '../utils/decoration.dart';
import '../utils/loading/src/loading_overlay.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  bool showpass = true;

  final formkey = GlobalKey<FormState>();

  loginUser() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {
          'vartraitement': '1',
          'phone': phoneCtrl.text,
          'pass': passCtrl.text,
        },
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        if (lst == null) {
          showToast(
            context,
            "Erreur de Connexion !",
            "Identifiants Invalides",
            type: ToastificationType.error,
          );
        } else {
          setState(() {
            connectedUser = User.fromMap(lst);
          });
          showToast(context, "Connexion réussie !", "A l'instant");
          ouvrirR(context, SideBarMenu());
        }
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

  @override
  void initState() {
    super.initState();
    setState(() {
      // phoneCtrl.text = "0140170107";
      // passCtrl.text = "ok";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      progressIndicator: loadingWidget(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FB5Row(
            classNames: 'justify-content-center',
            children: [
              FB5Col(
                classNames: 'col-10 col-md-7 col-lg-5',
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Se Connecter",
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
                              child: Divider(
                                color: secondaryColor,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 160),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: secondaryColor,
                                thickness: 2,
                              ),
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
                              "Vous n'avez pas de compte ?",
                              style: TextStyle(fontSize: 14, fontFamily: 'sgn'),
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () {
                                ouvrirR(context, RegisterPage());
                              },
                              child: Text(
                                "Inscrivez-vous",
                                style: wtTitle(
                                  14,
                                  1,
                                  Colors.black,
                                  true,
                                  false,
                                ),
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
                          'Connexion',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        22,
                        () async {
                          if (formkey.currentState!.validate()) {
                            loginUser();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
