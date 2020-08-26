class UserSingle {
  static final UserSingle _singleton = UserSingle._internal();
  factory UserSingle() => _singleton;
  UserSingle._internal();
  static UserSingle get userData => _singleton;
  String firstName;
  String id;
  String bookName;
}
