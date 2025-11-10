
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
