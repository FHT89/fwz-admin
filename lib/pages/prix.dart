import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../utils/decoration.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class PrixPage extends StatefulWidget {
  const PrixPage({super.key});

  @override
  State<PrixPage> createState() => _Prixtate();
}

class _Prixtate extends State<PrixPage> {
  TextEditingController montantCtrl = TextEditingController();

  final formkey = GlobalKey<FormState>();
  List prixLst = [];

  fetchPrice() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {'vartraitement': '4', 'id': connectedUser.pseudo},
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        prixLst.clear();
        for (var i = 0; i < lst.length; i++) {
          prixLst.add({
            "idprix": lst[i]['idprix'].toString(),
            "montant": lst[i]['montant'].toString(),
          });
        }
        showToast(context, "Enregistrement Effectué !", "A l'instant");
        setState(() {});
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
        "Erreur de Chargement !",
        e.toString(),
        type: ToastificationType.error,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  addPrice() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      print({
        'vartraitement': '5',
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'idstructure': connectedUser.pseudo,
        'price': montantCtrl.text,
        'user': connectedUser.prenom,
      });
      var response = await http.post(
        url,
        body: {
          'vartraitement': '5',
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'idstructure': connectedUser.pseudo,
          'price': montantCtrl.text,
          'user': connectedUser.prenom,
        },
      );
      print("Result : ${response.body}");
      print("Status : ${response.statusCode}");
      // if (response.statusCode == 200) {
      showToast(context, "Enregistrement Effectué !", "A l'instant");
      setState(() {
        montantCtrl.text = "";
      });
      await fetchPrice();
      // } else {
      //   showToast(
      //     context,
      //     "Erreur Serveur !",
      //     response.body,
      //     type: ToastificationType.error,
      //   );
      // }
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
    fetchPrice();
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
                      "Mes Prix",
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

                    // Add Price
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
                              "Ajouter",
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
                                  await addPrice();
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
                              controller: montantCtrl,
                              keyboardType: TextInputType.number,
                              decoration: mydecoration(
                                'Montant',
                                15,
                                12,
                                true,
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on_outlined,
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
                                  return "Obligatoire";
                                } else if (prixLst
                                    .where(
                                      (p) => p['montant'] == value.toString(),
                                    )
                                    .isNotEmpty) {
                                  return "Le prix Existe déjà";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            //
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(color: primaryColor, thickness: 2),
                          ),
                        ],
                      ),
                    ),

                    // Show Prices
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
                            "Prix Disponibles",
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
                        horizontal: 10,
                      ),
                      child: Column(
                        children: [
                          prixLst.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        "Aucun Prix Disponible !",
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
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            headingTextStyle: wtTitle(
                                              16,
                                              1,
                                              Colors.black,
                                              true,
                                              false,
                                            ),
                                            columns: const [
                                              DataColumn(label: Text("N°")),
                                              DataColumn(
                                                label: Text("Montant"),
                                              ),
                                            ],
                                            rows: prixLst.map((e) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      (prixLst.indexOf(e) + 1)
                                                          .toString(),
                                                    ),
                                                    // e["idprix"].toString()
                                                  ),
                                                  DataCell(Text(e["montant"])),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    //
                    //
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
}
