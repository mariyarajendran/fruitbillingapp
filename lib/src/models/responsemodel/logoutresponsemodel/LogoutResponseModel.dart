class LogoutResponseModel {
  bool success;
  String message;
  String errorMessage;

  LogoutResponseModel({this.success, this.message, this.errorMessage});

  LogoutResponseModel.fromMap(Map<String, dynamic> map)
      : success = map['success'] ?? false,
        message = map['message'] ?? '',
        errorMessage = map['errorMessage'] ?? '';
}
