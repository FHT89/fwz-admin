import 'package:flutter/material.dart';

class Category {
  String libcateg;
  String numcateg;

  Category({required this.libcateg, required this.numcateg});

  ///
  Map<String, dynamic> toMap() {
    return {'libcateg': libcateg, 'numcateg': numcateg};
  }

  ///
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      libcateg: map['libcateg'].toString(),
      numcateg: map['numcateg'].toString(),
    );
  }
}

class Produit {
  String codvente;
  String codprod;
  String libprod;
  String numcateg;
  double prixprod;
  double prixa;
  double prixb;
  double qte;
  double montant;

  Produit({
    required this.codvente,
    required this.codprod,
    required this.libprod,
    required this.numcateg,
    required this.prixprod,
    required this.prixa,
    required this.prixb,
    required this.qte,
    required this.montant,
  });

  ///
  Map<String, dynamic> toMap() {
    return {
      'codvente': codvente,
      'codprod': codprod,
      'libprod': libprod,
      'numcateg': numcateg,
      'prixprod': prixprod,
      'prixa': prixa,
      'prixb': prixb,
      'qte': qte,
      'montant': montant,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Produit && other.codprod == codprod);

  @override
  int get hashCode => codprod.hashCode;

  ///
  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      codvente: map['codvente'].toString(),
      codprod: map['codprod'].toString(),
      libprod: map['libprod'].toString(),
      numcateg: map['numcateg'].toString(),
      prixprod:
          double.tryParse((map['prixprod'] ?? map['prixvente']).toString()) ??
          0,
      prixa: double.tryParse(map['prixa'].toString()) ?? 0,
      prixb: double.tryParse(map['prixb'].toString()) ?? 0,
      qte: double.tryParse(map['qtevente'].toString()) ?? 0,
      montant: double.tryParse(map['montprod'].toString()) ?? 0,
    );
  }
}

//
class Vente {
  String codvente;
  String datevente;
  String numcli;
  String montapayer;
  String typvente;
  String reduc;
  String montapayerreduc;
  String tva;
  String ttc;
  String montremis;
  String monnaie;
  String modepaie;
  String qr;
  String signature;
  String nim;
  String compteur;
  String heure;
  String tc;
  String etatfact;
  String numagent;
  String idpointvente;
  String user;
  String numfam;
  String sup;
  Client? client;

  Vente({
    required this.codvente,
    required this.datevente,
    required this.numcli,
    required this.montapayer,
    required this.typvente,
    required this.reduc,
    required this.montapayerreduc,
    required this.tva,
    required this.ttc,
    required this.montremis,
    required this.monnaie,
    required this.modepaie,
    required this.qr,
    required this.signature,
    required this.nim,
    required this.compteur,
    required this.heure,
    required this.tc,
    required this.etatfact,
    required this.numagent,
    required this.idpointvente,
    required this.user,
    required this.numfam,
    required this.sup,
  });

  ///
  Map<String, dynamic> toMap() {
    return {
      'codvente': codvente,
      'datevente': datevente,
      'numcli': numcli,
      'montapayer': montapayer,
      'typvente': typvente,
      'reduc': reduc,
      'montapayer_reduc': montapayerreduc,
      'tva': tva,
      'ttc': ttc,
      'montremis': montremis,
      'monnaie': monnaie,
      'modepaie': modepaie,
      'qr': qr,
      'signature': signature,
      'nim': nim,
      'compteur': compteur,
      'heure': heure,
      'tc': tc,
      'etatfact': etatfact,
      'numagent': numagent,
      'idpointvente': idpointvente,
      'user': user,
      'numfam': numfam,
      'sup': sup,
    };
  }

  ///
  factory Vente.fromMap(Map<String, dynamic> map) {
    Vente tmp = Vente(
      codvente: map['codvente'].toString(),
      datevente: map['datevente'].toString(),
      numcli: map['numcli'].toString(),
      montapayer: map['montapayer'].toString(),
      typvente: map['typvente'].toString(),
      reduc: map['reduc'].toString(),
      montapayerreduc: map['montapayer_reduc'].toString(),
      tva: map['tva'].toString(),
      ttc: map['ttc'].toString(),
      montremis: map['montremis'].toString(),
      monnaie: map['monnaie'].toString(),
      modepaie: map['modepaie'].toString(),
      qr: map['qr'].toString(),
      signature: map['signature'].toString(),
      nim: map['nim'].toString(),
      compteur: map['compteur'].toString(),
      heure: map['heure'].toString(),
      tc: map['tc'].toString(),
      etatfact: map['etatfact'].toString(),
      numagent: map['numagent'].toString(),
      idpointvente: map['idpointvente'].toString(),
      user: map['user'].toString(),
      numfam: map['numfam'].toString(),
      sup: map['sup'].toString(),
    );
    return tmp;
  }
}

//

class User {
  String pseudo;
  String nom;
  String prenom;
  String mot;
  String fonction;
  String user;
  String idpointvente;
  String libptvente;
  String token = "";

  User({
    required this.pseudo,
    required this.nom,
    required this.prenom,
    required this.mot,
    required this.fonction,
    required this.user,
    required this.idpointvente,
    required this.libptvente,
  });

  ///
  Map<String, dynamic> toMap() {
    return {
      'pseudo': pseudo,
      'nom': nom,
      'prenom': prenom,
      'mot': mot,
      'fonction': fonction,
      'user': user,
      'idpointvente': idpointvente,
      'libptvente': libptvente,
      'token': token,
    };
  }

  ///
  factory User.fromMap(Map<String, dynamic> map) {
    // New Map
    // {idstructure: 78910, libstructure: Hafiz Test, adstructure: Porto, telphstructure: 0161648007, mpstructure: holo, datedeb: null, datefin: null, etat: 1}
    User tmp = User(
      pseudo: map['idstructure'].toString(),
      nom: map['libstructure'].toString(),
      prenom: map['telphstructure'].toString(),
      mot: map['mpstructure'].toString(),
      fonction: map['fonction'] ?? '',
      user: map['user'].toString(),
      idpointvente: map['idpointvente'] ?? '',
      libptvente: map['adstructure'].toString(),
    );
    tmp.token = map['token'] ?? '';
    return tmp;
  }
}

class Client {
  String numcli;
  String nomcli;
  String adresscli;
  String email;
  String telph;
  String rccm;
  String ifu;
  String pseudo;
  String etatcli;
  String datecreation;
  String nomstruc;
  String reduc;
  String codebarre;

  Client({
    required this.numcli,
    required this.nomcli,
    required this.adresscli,
    required this.email,
    required this.telph,
    required this.rccm,
    required this.ifu,
    required this.pseudo,
    required this.etatcli,
    required this.datecreation,
    required this.nomstruc,
    required this.reduc,
    required this.codebarre,
  });

  ///
  Map<String, dynamic> toMap() {
    return {
      'numcli': numcli,
      'nomcli': nomcli,
      'adresscli': adresscli,
      'email': email,
      'telph': telph,
      'rccm': rccm,
      'ifu': ifu,
      'pseudo': pseudo,
      'etatcli': etatcli,
      'datecreation': datecreation,
      'nomstruc': nomstruc,
      'reduc': reduc,
      'codebarre': codebarre,
    };
  }

  ///
  factory Client.fromMap(Map<String, dynamic> map) {
    Client tmp = Client(
      numcli: map['numcli'].toString(),
      nomcli: map['nomcli'].toString(),
      adresscli: map['adresscli'].toString(),
      email: map['email'].toString(),
      telph: map['telph'].toString(),
      rccm: map['rccm'].toString(),
      ifu: map['ifu'].toString(),
      pseudo: map['pseudo'].toString(),
      etatcli: map['etatcli'].toString(),
      datecreation: map['datecreation'].toString(),
      nomstruc: map['nomstruc'].toString(),
      reduc: map['reduc'].toString(),
      codebarre: map['codebarre'].toString(),
    );
    return tmp;
  }
}

//
// Facturation
//
class CFact {
  CFact({
    required this.numordre,
    required this.designation,
    required this.qte,
    required this.prixht,
    required this.mtht,
    required this.grp,
    required this.tva,
    required this.prixttc,
    required this.reduc,
    required this.mtttc,
    required this.mtva,
  });
  int numordre;
  String designation;
  String qte;
  String prixht;
  String mtht;
  String grp;
  String tva;
  String prixttc, reduc;
  String mtttc;
  String mtva;
}

class CFactTaxe {
  CFactTaxe({
    required this.numordre,
    required this.grp,
    required this.tht,
    required this.tva,
    required this.mttc,
  });
  int numordre;
  String grp;
  String tht;
  String tva;
  String mttc;
}

class CClients {
  CClients({
    required this.numordre,
    required this.numcli,
    required this.nomcli,
    required this.nomstruc,
    required this.adresscli,
    required this.email,
    required this.telph,
    required this.rccm,
    required this.ifu,
    required this.reduc,
    required this.codebarre,
  });

  int numordre;
  String numcli;
  String nomcli;
  String nomstruc;
  String adresscli;
  String email;
  String ifu;
  String rccm;
  String telph, reduc, codebarre;
}

class CLVenteMode {
  CLVenteMode({
    required this.mode,
    required this.montant,
    required this.reference,
  });
  int mode;
  TextEditingController montant, reference;
}

class CParamSite {
  CParamSite({
    required this.numordre,
    required this.idpointvente,
    required this.libptvente,
    required this.numfam,
    required this.libfam,
    required this.adresse,
    required this.ifu,
    required this.rccm,
    required this.telph,
  });

  int numordre;
  String idpointvente;
  String libptvente;
  String numfam;
  String libfam;
  String adresse;
  String ifu;
  String rccm;
  String telph;
}

class CModepaiement {
  CModepaiement({required this.id, required this.lib, required this.ordre});
  int id, ordre;
  String lib;
}
