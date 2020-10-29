class FundedWallet {
  String status;
  String message;
  Data data;

  FundedWallet({this.status, this.message, this.data});

  factory FundedWallet.fromJson(Map<String, dynamic> json) {
    return FundedWallet(
        status: json['status'],
        message: json['message'],
        data: Data.fromJson(json['data']));
  }
}

class Data {
  int amount;
  String raveRef;

  Data({this.amount, this.raveRef});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(amount: json['amount'], raveRef: json['raveRef']);
  }
}

class FundedWalletInServer {
  String message;
  String balance;

  FundedWalletInServer({this.message, this.balance});

  factory FundedWalletInServer.fromJson(Map<String, dynamic> json) {
    return FundedWalletInServer(
        message: json['Message'], balance: json['balance']);
  }
}
