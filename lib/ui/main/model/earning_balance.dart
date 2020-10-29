/// balance : 16687

class EarningBalance {
  int _balance;

  int get balance => _balance;

  EarningBalance({
      int balance}){
    _balance = balance;
}

  EarningBalance.fromJson(dynamic json) {
    _balance = json["balance"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["balance"] = _balance;
    return map;
  }

}