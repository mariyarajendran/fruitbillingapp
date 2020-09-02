class ResetResponseModel {
  bool success;
  String message;
  String errorMessage;

  ResetResponseModel({this.success, this.message, this.errorMessage});

  ResetResponseModel.fromMap(Map<String, dynamic> map)
      : success = map['success'] ?? false,
        message = map['message'] ?? '',
        errorMessage = map['errorMessage'] ?? '';
}
