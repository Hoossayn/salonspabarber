/// balance : 1500

class WalletBalance{
  int _balance;

  int get balance => _balance;

  WalletBalance({
      int balance}){
    _balance = balance;
}

  WalletBalance.fromJson(dynamic json) {
    _balance = json["balance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["balance"] = _balance;
    return map;
  }

}