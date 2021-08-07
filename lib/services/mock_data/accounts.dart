import 'package:rutorrentflutter/models/account.dart';

List<Account> _accounts = [
  Account(
    username: "dev",
    password: "dev",
    url: "https://devapiservice.com/rtorrent",
  )
];

List<Account> get devAccounts => _accounts;

void devPasswordChange(String? username, String password) {
  Account account =
      _accounts.firstWhere((account) => account.username == username);
  account.password = password;
}
