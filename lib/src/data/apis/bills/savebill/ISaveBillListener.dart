abstract class ISaveBillListener {
  String getCustomerId();

  String getPendingAmount();

  String getTotalAmount();

  String getReceivedAmount();

  void postSaveBillData();

  Map parseSaveBillData();

  void errorValidationMgs(String error);

  void onSuccessResponseSaveBill(String msg);

  void onFailureMessageSaveBill(String error);
}
