class SuccessMsg {
  late String success;

  SuccessMsg({required this.success});

  SuccessMsg.fromMap(Map<String, dynamic> map) {
    this.success = map["success"];
  }
}
