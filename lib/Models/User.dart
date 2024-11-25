class User {
  final int id; // Ora opzionale
  final String username;
  final String passwordHash;

  //costruttore
  User(  {
    required this.id,
    required this.username,
    required this.passwordHash
  });

  factory User.buildUser(String id, String? username, String? passwordHash) {
    return User(
      id: int.tryParse(id ?? '0') ?? 0, // Conversione sicura.
      username: username ?? '',
      passwordHash: passwordHash ?? '',
    );
  }

  // Getters Function

  String get getId => id.toString();

  String get getUsername => username;

  String get getPasswordHash => passwordHash;

  /// Metodo per deserializzare un oggetto JSON in un'istanza di Student
  /// Utilizzato quando devo ricevere dati dal Server
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      username: json['username'],
      passwordHash: json['passwordHash'],
      id: json['ID'],
    );
  }

  // Metodo per creare una copia dell'oggetto
  /*User copyWith({
    int? id,
    String? username,
    String? passwordHash,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
    );
  }*/

  // Metodo per rappresentare la classe come una stringa (utile per il debug)
  @override
  String toString() {
    return 'User(id: $id, username: $username, passwordHash: $passwordHash)';
  }
}
