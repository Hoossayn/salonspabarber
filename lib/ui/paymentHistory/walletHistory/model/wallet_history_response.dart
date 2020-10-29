
class WalletHistoryResponse {
  List<WalletHistory> history;

  WalletHistoryResponse({this.history});


  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    var cList = json['history'] as List;

    List<WalletHistory> orders = cList.map((i) => WalletHistory.fromJson(i)).toList();
    return WalletHistoryResponse(history: orders);
  }
}

class WalletHistory {
  int id;
  String amount;
  String reference;
  String userid;
  String paidAt;
  dynamic centre;
  dynamic address;

  WalletHistory(
      {this.id,
        this.amount,
        this.reference,
        this.userid,
        this.paidAt,
        this.centre,
        this.address});

  factory WalletHistory.fromJson(Map<String, dynamic> json){
    return WalletHistory(
        id : json['id'],
        amount : json['amount'],
        reference : json['reference'],
        userid : json['userid'],
        paidAt : json['paid_at'],
        centre : json['centre'],
        address : json['address'],
    );

  }
}