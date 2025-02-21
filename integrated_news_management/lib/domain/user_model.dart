class User {
  final String id;
  final String username;
  final String password;
  String _roles;
  String _status;

  User(
      {this.id = "",
      required this.username,
      required this.password,
      String roles = "user",
      String status = "unblocked"})
      : _roles = roles,
        _status = status;
}
