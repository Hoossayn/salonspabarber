/// Message : "Success!"

class WithdrawResponse {
  String _message;

  String get message => _message;

  WithdrawResponse({
      String message}){
    _message = message;
}

  WithdrawResponse.fromJson(dynamic json) {
    _message = json["Message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["Message"] = _message;
    return map;
  }

}