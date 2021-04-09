class Account {
  String url;
  String username;
  String password;
  bool _isSeedboxAccount;

  Account({this.url, this.username, this.password});

  Account.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['username'] = this.username;
    data['password'] = this.password;
    data['isSeedboxAccount'] = this.isSeedboxAccount;
    return data;
  }

  bool get isSeedboxAccount {
    _isSeedboxAccount = username.isNotEmpty && password.isNotEmpty;
    return _isSeedboxAccount;
  }
}
