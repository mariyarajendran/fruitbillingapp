class SaveBillResponseModel {
  bool success;
  String message;
  int code;

  SaveBillResponseModel({this.success, this.message, this.code});

  SaveBillResponseModel.fromMapStatus(Map<String, dynamic> map)
      : success = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        code = map['code'] ?? 0;
}
