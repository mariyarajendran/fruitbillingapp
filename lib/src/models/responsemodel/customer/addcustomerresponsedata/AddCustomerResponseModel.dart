class AddCustomerResponseModel {
  bool success;
  String message;
  int code;

  AddCustomerResponseModel({this.success, this.message, this.code});

  AddCustomerResponseModel.fromMapStatus(Map<String, dynamic> map)
      : success = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        code = map['code'] ?? 0;
}
