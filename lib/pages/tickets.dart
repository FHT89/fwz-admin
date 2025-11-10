import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap5/flutter_bootstrap5.dart';
import '../globals.dart';
import '../utils/decoration.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _Prixtate();
}

class _Prixtate extends State<TicketsPage> {
  final ScrollController _scrollControllerV = ScrollController();
  final ScrollController _scrollControllerH = ScrollController();
  final ScrollController _scrollControllerV2 = ScrollController();
  final ScrollController _scrollControllerH2 = ScrollController();

  final formkey = GlobalKey<FormState>();
  List ticketsLst = [];
  var prix;
  List prixLst = [];
  var uuid = const Uuid();

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

  fetchTickets() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var response = await http.post(
        url,
        body: {'vartraitement': '6', 'id': connectedUser.pseudo},
      );
      var lst = jsonDecode(response.body);
      print("Result : $lst");
      if (response.statusCode == 200) {
        ticketsLst.clear();
        for (var i = 0; i < lst.length; i++) {
          ticketsLst.add({
            "idtickets": lst[i]['idtickets'].toString(),
            "datecreation": lst[i]['datecreation'].toString(),
            "code": lst[i]['code'].toString(),
            "consome": lst[i]['consome'].toString(),
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

  addTickets() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('$backendUrl/structure.php');
    try {
      var data = jsonEncode(
        rows
            .where((r) => r[1].toString().isNotEmpty)
            .map(
              (e) => {
                "idtickets": uuid.v4(),
                // UniqueKey().toString(), // DateTime.now().microsecondsSinceEpoch.toString(),
                "datecreation": '',
                "code": e[1].toString(),
                "consome": '0',
                "idprix": prix.toString(),
                "user": connectedUser.prenom,
              },
            )
            .toList(),
      );
      print(data);
      var response = await http.post(
        url,
        body: {'vartraitement': '7', 'data': data},
      );
      print("Result : ${response.body}");
      print("Status : ${response.statusCode}");
      if (response.statusCode == 200) {
        showToast(context, "Enregistrement Effectué !", "A l'instant");
        setState(() {
          columnNames.clear();
          rows.clear();
        });
        await fetchTickets();
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
        "Erreur de sauvegarde !",
        e.toString(),
        type: ToastificationType.error,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  List<String> columnNames = [];
  List<List<dynamic>> rows = [];

  _selectFile() async {
    setState(() {
      isLoading = true;
    });
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    final file = result.files.single;
    final bytes = file.bytes ?? await File(file.path!).readAsBytes();
    String csvString = utf8.decode(bytes);

    // --- CLEANUP ---
    // Remove BOM if present
    if (csvString.startsWith('\uFEFF')) {
      csvString = csvString.substring(1);
    }
    // Normalize newlines (Windows -> Unix)
    csvString = csvString.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    // Trim overall
    csvString = csvString.trim();

    // Debug: print raw
    // print("--- RAW CSV ---\n$csvString\n--- END RAW ---");

    if (csvString.isEmpty) return;

    // Split into lines and remove empty lines
    final allLines = csvString
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (allLines.isEmpty) return;

    // First line = header
    final headerLine = allLines.first;
    // IMPORTANT: split on comma without removing empty fields
    List<String> headers = headerLine.split(',').map((h) => h.trim()).toList();

    // Validate header matches expected (optional)
    // final expected = ['Username','Password','Profile','Time Limit','Data Limit','Comment'];
    // if (headers.length != expected.length) { /* handle mismatch if needed */ }

    // Remaining lines = data rows
    final dataLines = allLines.skip(1).toList();

    List<List<String>> parsedRows = [];

    for (var line in dataLines) {
      // Split preserving empty fields
      List<String> cells = line.split(',').map((c) => c.trim()).toList();

      // If a cell contains commas but is quoted (e.g. "a,b"), handle naive quotes:
      // (Your dataset doesn't have quotes, but here's a basic fix.)
      if (cells.length > headers.length) {
        // Try naive rejoin: if there are extra columns, merge extras into last column
        // This keeps the rest of the row consistent.
        final fixed = <String>[];
        for (var i = 0; i < headers.length - 1; i++) {
          fixed.add(i < cells.length ? cells[i] : '');
        }
        // merge remaining tokens into last column
        final last = cells.sublist(headers.length - 1).join(',');
        fixed.add(last);
        cells = fixed;
      }

      // Pad with empty strings if shorter
      while (cells.length < headers.length) {
        cells.add('');
      }

      parsedRows.add(cells);
    }

    setState(() {
      columnNames = headers;
      rows = parsedRows;
    });

    setState(() {});
    // print(columnNames);
    // print(rows);
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    fetchTickets();
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
                classNames: 'col-10 col-lg-8',
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Mes Tickets",
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
                                await _selectFile();
                                await fetchPrice();
                              },
                              child: Text(
                                "Importer Fichier",
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
                            rows.isEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Text(
                                          "Aucun CSV Chargé !",
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
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField(
                                            value: prix,
                                            dropdownColor: Colors.white,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Précisez le Prix des tickets';
                                              }
                                              return null;
                                            },
                                            decoration: mydecoration(
                                              'Prix',
                                              15,
                                              12,
                                              true,
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: 15,
                                                ),
                                                width: 60,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .monetization_on_outlined,
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
                                              BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            isExpanded: true,
                                            onChanged: (value) {
                                              prix = value!;
                                              setState(() {});
                                            },
                                            items: prixLst
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    value: e['idprix'],
                                                    child: Text(
                                                      ' ${e['montant']} F',
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                       const SizedBox(height: 10),   
                                       Text(
                              "Veillez à ce que les codes soient dans la 2e colonne. Sinon Corrigez et rechargez le fichier",
                              style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 127, 99, 0)),
                              textAlign: TextAlign.center,
                            ),
                                      const SizedBox(height: 10),
                                      customButton(
                                        primaryColor,
                                        Text(
                                          'Valider',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        22,
                                        () async {
                                          if (formkey.currentState!
                                              .validate()) {
                                            await addTickets();
                                          }
                                        },
                                        -15,
                                        cp: EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 40,
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      // DataTable
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight: 500,
                                        ),
                                        alignment: Alignment.center,
                                        child: Scrollbar(
                                          controller: _scrollControllerV2,
                                          thumbVisibility: true,
                                          trackVisibility: true,
                                          child: SingleChildScrollView(
                                            controller: _scrollControllerV2,
                                            scrollDirection: Axis.vertical,
                                            child: Scrollbar(
                                              controller: _scrollControllerH2,
                                              thumbVisibility: true,
                                              //trackVisibility: true,
                                              child: SingleChildScrollView(
                                                controller: _scrollControllerH2,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Card(
                                                  child: Column(
                                                    //mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      DataTable(
                                                        headingTextStyle:
                                                            wtTitle(
                                                              16,
                                                              1,
                                                              Colors.black,
                                                              true,
                                                              false,
                                                            ),
                                                        columns: columnNames
                                                            .map(
                                                              (name) =>
                                                                  DataColumn(
                                                                    label: Text(
                                                                      name,
                                                                    ),
                                                                  ),
                                                            )
                                                            .toList(),
                                                        rows: rows.map((row) {
                                                          return DataRow(
                                                            cells: List.generate(
                                                              columnNames
                                                                  .length,
                                                              (i) {
                                                                return DataCell(
                                                                  Text(
                                                                    i <
                                                                            row.length
                                                                        ? row[i]
                                                                              .toString()
                                                                        : "",
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            //
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

                    // Show Tickets
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
                            "Tickets Enregistrés",
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
                          ticketsLst.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      child: Text(
                                        "Aucun Ticket Disponible !",
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
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //
                                    Padding(
                                      padding: EdgeInsetsGeometry.symmetric(
                                        horizontal: 15,
                                        vertical: 8,
                                      ),
                                      child: FB5Row(
                                        children: [
                                          FB5Col(
                                            classNames: 'col-12 col-md-6',
                                            child: rowInfo(
                                              "Total Disponible : ",
                                              ticketsLst
                                                  .where(
                                                    (t) => t["consome"] == '0',
                                                  )
                                                  .length
                                                  .toString(),
                                              mainCol: Colors.green,
                                            ),
                                          ),
                                          FB5Col(
                                            classNames: 'col-12 col-md-6',
                                            child: rowInfo(
                                              "Total Vendus : ",
                                              ticketsLst
                                                  .where(
                                                    (t) => t["consome"] == '1',
                                                  )
                                                  .length
                                                  .toString(),
                                              mainCol: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    Container(
                                      constraints: BoxConstraints(
                                        minHeight: 200,
                                        maxHeight: 500,
                                      ),
                                      alignment: Alignment.center,
                                      child: Scrollbar(
                                        controller: _scrollControllerV,
                                        thumbVisibility: true,
                                        trackVisibility: true,
                                        child: SingleChildScrollView(
                                          controller: _scrollControllerV,
                                          scrollDirection: Axis.vertical,
                                          child: Scrollbar(
                                            controller: _scrollControllerH,
                                            thumbVisibility: true,
                                            //trackVisibility: true,
                                            child: SingleChildScrollView(
                                              controller: _scrollControllerH,
                                              scrollDirection: Axis.horizontal,
                                              child: Card(
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    DataTable(
                                                      headingTextStyle: wtTitle(
                                                        16,
                                                        1,
                                                        Colors.black,
                                                        true,
                                                        false,
                                                      ),
                                                      columns: const [
                                                        DataColumn(
                                                          label: Text("N°"),
                                                        ),
                                                        DataColumn(
                                                          label: Text("Prix"),
                                                        ),
                                                        DataColumn(
                                                          label: Text("Code"),
                                                        ),
                                                        DataColumn(
                                                          label: Text("Status"),
                                                        ),
                                                        DataColumn(
                                                          label: Text(
                                                            "Créé le",
                                                          ),
                                                        ),
                                                      ],
                                                      rows: ticketsLst.map((e) {
                                                        Color col =
                                                            e["consome"] == '0'
                                                            ? Colors.green
                                                            : Colors.red;

                                                        String status =
                                                            e["consome"] == '0'
                                                            ? "Disponible"
                                                            : "Vendu";
                                                        return DataRow(
                                                          cells: [
                                                            DataCell(
                                                              Text(
                                                                (ticketsLst.indexOf(
                                                                          e,
                                                                        ) +
                                                                        1)
                                                                    .toString(),
                                                              ),
                                                              // e["idprix"].toString()
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                e["montant"],
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(e["code"]),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                status,
                                                                style:
                                                                    TextStyle(
                                                                      color:
                                                                          col,
                                                                    ),
                                                              ),
                                                            ),
                                                            DataCell(
                                                              Text(
                                                                e["datecreation"]
                                                                    .toString()
                                                                    .split(
                                                                      ' ',
                                                                    )[0],
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
