class User {
  final int id; // Ora opzionale
  final String username;
  final String passwordHash;
  final String email;

  //costruttore
  User(  {
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.email
  });

  factory User.buildUser(String id, String? username, String? passwordHash, String? email) {
    return User(
      id: int.tryParse(id ?? '0') ?? 0, // Conversione sicura.
      username: username ?? '',
      passwordHash: passwordHash ?? '',
      email: email ?? '',
    );
  }

  // Getters Function

  String get getId => id.toString();

  String get getUsername => username;

  String get getPasswordHash => passwordHash;

  String get getEmail => email;

  /// Metodo per deserializzare un oggetto JSON in un'istanza di Student
  /// Utilizzato quando devo ricevere dati dal Server
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      username: json['username'],
      passwordHash: json['passwordHash'],
      id: json['ID'],
      email: json['email'],
    );
  }

  // Metodo per rappresentare la classe come una stringa (utile per il debug)
  @override
  String toString() {
    return 'User(id: $id, username: $username, passwordHash: $passwordHash, email: $email)';
  }
}
