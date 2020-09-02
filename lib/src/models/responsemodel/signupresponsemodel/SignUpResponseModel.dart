class SignUpResponseModel {
  String location;

  SignUpResponseModel({
    this.location,
  });

  SignUpResponseModel.fromMap(Map<String, dynamic> map)
      : location = map['location'];
}
