/// history : [{"amount":500,"request_date":"2020-08-13 23:11:51","status":1},{"amount":500,"request_date":"2020-08-15 11:22:00","status":1}]

class EarningHistoryResponse {
  List<EarnHistory> history;


  EarningHistoryResponse({this.history});

  factory EarningHistoryResponse.fromJson(Map<String, dynamic> json) {
    var cList = json['history'] as List;

    List<EarnHistory> orders = cList.map((i) => EarnHistory.fromJson(i)).toList();
    return EarningHistoryResponse(history: orders);
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (history != null) {
      map["history"] = history.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// amount : 500
/// request_date : "2020-08-13 23:11:51"
/// status : 1

class EarnHistory {
  int amount;
  String requestDate;
  int status;


  EarnHistory({
    this.amount,
    this.requestDate,
    this.status});

  factory EarnHistory.fromJson(Map<String, dynamic> json) {
    return EarnHistory(
        amount : json["amount"],
        requestDate : json["requestDate"],
        status : json["status"],
    );
  }


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["amount"] = amount;
    map["requestDate"] = requestDate;
    map["status"] = status;
    return map;
  }

}