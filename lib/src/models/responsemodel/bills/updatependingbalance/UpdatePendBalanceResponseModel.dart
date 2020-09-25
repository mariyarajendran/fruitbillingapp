class UpdatePendBalanceResponseModel {
  bool success;
  String message;
  int code;

  UpdatePendBalanceResponseModel({this.success, this.message, this.code});

  UpdatePendBalanceResponseModel.fromMapStatus(Map<String, dynamic> map)
      : success = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        code = map['code'] ?? 0;
}
