import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../utils/decoration.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _Prixtate();
}

class _Prixtate extends State<StatsPage> {
  List statsLst = [], demandesLst = [];
  double totalDisp = 0;
  double totalDem = 0;

  fetchDemandes() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {'vartraitement': '9', 'id': connectedUser.pseudo},
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        demandesLst.clear();
        for (var i = 0; i < lst.length; i++) {
          demandesLst.add({
            "date": lst[i]['date'].toString(),
            "montant": lst[i]['montant'].toString(),
            "refpaiement": lst[i]['refpaiement'] ?? " ---  ",
            "datepaiement": lst[i]['datepaiement'] ?? " --- ",
            "etat": lst[i]['etat'].toString(),
          });
          if (lst[i]['etat'].toString() == '0') {
            totalDem =
                totalDem + (double.tryParse(lst[i]['montant'].toString()) ?? 0);
          }
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

  fetchStats() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {'vartraitement': '8', 'id': connectedUser.pseudo},
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        statsLst.clear();
        for (var i = 0; i < lst.length; i++) {
          statsLst.add({
            "idprix": lst[i]['idprix'].toString(),
            "montant": lst[i]['montant'].toString(),
            "total_tikets": lst[i]['total_tikets'].toString(),
            "mt_total_tikets": lst[i]['mt_total_tikets'].toString(),
            "total_dispo": lst[i]['total_dispo'].toString(),
            "mt_total_dispo": lst[i]['mt_total_dispo'].toString(),
            "total_vendu": lst[i]['total_vendu'].toString(),
            "mt_total_vendu": lst[i]['mt_total_vendu'].toString(),
            "mt_total_retrait": lst[i]['mt_total_retrait'].toString(),
          });
          totalDisp =
              totalDisp +
              (double.tryParse(lst[i]['mt_total_retrait'].toString()) ?? 0);
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

  demandeRetrait() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      print({
        'vartraitement': '10',
        'idstructure': connectedUser.pseudo,
        'montant': (totalDisp - totalDem).toString(),
      });
      var response = await http.post(
        url,
        body: {
          'vartraitement': '10',
          'idstructure': connectedUser.pseudo,
          'montant': totalDisp.toString(),
        },
      );
      print("Result : ${response.body}");
      print("Status : ${response.statusCode}");
      if (response.statusCode == 200) {
        showToast(context, "Enregistrement Effectué !", "A l'instant");
        setState(() {});
        await fetchStats();
        await fetchDemandes();
      } else {
        showToast(
          context,
          "Erreur Serveur !",
          response.body,
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

  data() async {
    await fetchDemandes();
    await fetchStats();
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
        backgroundColor: secondaryColor3,
        body: SingleChildScrollView(
          child: FB5Row(
            classNames: 'justify-content-center',
            children: [
              FB5Col(
                classNames: 'col-10',
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Statistiques",
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
                              "Balance",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                            InkWell(
                              onTap: () async {
                                if ((totalDisp - totalDem) == 0) {
                                  showToast(
                                    context,
                                    "Erreur",
                                    "Aucun Solde Disponible pour retrait !",
                                    type: ToastificationType.error,
                                  );
                                } else {
                                  await demandeRetrait();
                                }
                              },
                              child: Text(
                                "Demander",
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.monetization_on_outlined,
                                  size: 40,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${totalDisp - totalDem} F",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Montant Total Disponible pour Retrait",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.mobile_friendly_outlined,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 40,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalDisp F",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Montant Total en Balance",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.mode_standby_outlined,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),
                          //
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.money_off_outlined,
                                  size: 40,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$totalDem F",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Montant Total en Cours de Demande",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.mode_standby_outlined,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ),

                          //
                          SizedBox(height: 10),
                          //
                        ],
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
                            "Prix et Tickets",
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
                          statsLst.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        "Aucune Donnée Disponible !",
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
                                              DataColumn(label: Text("Prix")),
                                              DataColumn(
                                                label: Text(
                                                  "Total Tickets (TT)",
                                                ),
                                              ),
                                              DataColumn(label: Text("Mt TT")),
                                              DataColumn(
                                                label: Text("Total Disp (TD)"),
                                              ),
                                              DataColumn(label: Text("Mt TD")),
                                              DataColumn(
                                                label: Text("Total Vendu (TV)"),
                                              ),
                                              DataColumn(label: Text("Mt TV")),
                                              DataColumn(
                                                label: Text("Solde Disponible"),
                                              ),
                                            ],
                                            rows: statsLst.map((e) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      (statsLst.indexOf(e) + 1)
                                                          .toString(),
                                                    ),
                                                    // e["idprix"].toString()
                                                  ),
                                                  DataCell(
                                                    Text("${e["montant"]} F"),
                                                  ),
                                                  DataCell(
                                                    Text(e["total_tikets"]),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      "${e["mt_total_tikets"]} F",
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(e["total_dispo"]),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      "${e["mt_total_dispo"]} F",
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(e["total_vendu"]),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      "${e["mt_total_vendu"]} F",
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      "${e["mt_total_retrait"]} F",
                                                    ),
                                                  ),
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

                    // Show Demandes
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
                            "Historique des Demandes",
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
                          demandesLst.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        "Aucune Donnée Disponible !",
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
                                                label: Text("Date Demande"),
                                              ),
                                              DataColumn(
                                                label: Text("Montant"),
                                              ),
                                              DataColumn(label: Text("Status")),
                                              DataColumn(label: Text("Ref")),
                                              DataColumn(
                                                label: Text("Date Paiement"),
                                              ),
                                            ],
                                            rows: demandesLst.map((e) {
                                              Color col = e["etat"] == '0'
                                                  ? const Color.fromARGB(
                                                      255,
                                                      115,
                                                      86,
                                                      0,
                                                    )
                                                  : e["etat"] == '1'
                                                  ? Colors.green
                                                  : Colors.red;

                                              String status = e["etat"] == '0'
                                                  ? "En Cours de Traitement"
                                                  : e["etat"] == '1'
                                                  ? "Validé"
                                                  : "Refusé";
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Text(
                                                      (demandesLst.indexOf(e) +
                                                              1)
                                                          .toString(),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text("${e["date"]}"),
                                                  ),
                                                  DataCell(
                                                    Text("${e["montant"]} F"),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      status,
                                                      style: TextStyle(
                                                        color: col,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text("${e["refpaiement"]}"),
                                                  ),
                                                  DataCell(
                                                    Text(e["datepaiement"]),
                                                  ),
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
