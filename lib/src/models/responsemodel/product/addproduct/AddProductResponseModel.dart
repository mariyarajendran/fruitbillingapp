class AddProductResponseModel {
  bool success;
  String message;
  int code;

  AddProductResponseModel({this.success, this.message, this.code});

  AddProductResponseModel.fromMapStatus(Map<String, dynamic> map)
      : success = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        code = map['code'] ?? 0;
}
