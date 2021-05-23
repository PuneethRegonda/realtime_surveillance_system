class SessionUser {
  final String username;
  final String email;
  final bool isAdmin;

  SessionUser({this.username, this.email, this.isAdmin=false });

  static SessionUser fromJSON(data) {
    return SessionUser(username: data['username'],email: data['email'],isAdmin: data['isadmin']);
  }
}
