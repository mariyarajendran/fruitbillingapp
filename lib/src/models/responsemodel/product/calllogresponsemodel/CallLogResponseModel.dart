class CallLogResponseModel {
  bool success;
  String message;
  String errorMessage;
  List<dynamic> callLogImportInfo;

  CallLogResponseModel(
      {this.success, this.message, this.errorMessage, this.callLogImportInfo});

  CallLogResponseModel.fromMap(Map<String, dynamic> map)
      : success = map['success'] ?? false,
        message = map['message'] ?? '',
        errorMessage = map['errorMessage'] ?? '',
        callLogImportInfo = map['callLogImportInfo'] ?? List();
}

class CallLogImportInfo {
  int callLogImportInfoId;
  int companyId;
  String companyName;
  String date;
  String caller;
  String dialed;
  String duration;
  String play;
  String active;
  String isCallBlocking;
  bool isBlocking = false;
  bool isExpanded = false;
  bool isChecked = false;

  CallLogImportInfo(
      {this.callLogImportInfoId,
      this.companyId,
      this.companyName,
      this.date,
      this.caller,
      this.dialed,
      this.duration,
      this.play,
      this.active,
      this.isCallBlocking,
      this.isBlocking});

  CallLogImportInfo.fromMap(Map<String, dynamic> map)
      : callLogImportInfoId = map['callLogImportInfoId'] ?? 0,
        companyId = map['companyId'] ?? 0,
        companyName = map['companyName'] ?? '',
        date = map['date'] ?? '',
        caller = map['caller'] ?? '',
        dialed = map['dialed'] ?? '',
        duration = map['duration'] ?? '',
        play = map['play'] ?? '',
        active = map['active'] ?? '',
        isCallBlocking = map['isCallBlocking'] ?? '';
}
