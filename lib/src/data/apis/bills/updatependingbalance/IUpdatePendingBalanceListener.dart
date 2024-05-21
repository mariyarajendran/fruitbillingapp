abstract class IUpdatePendingBalanceListener {
  String getOrderSummaryId();

  String getPendingAmount();

  String getReceivedAmount();

  String getOrderSummaryPendingAmount();

  String getOrderPendingHistoryReceivedAmount();

  String getOrderPendingHistoryPendingAmount();

  void postUpdatePendingBalanceData();

  Map parseUpdatePendingBalanceData();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdatePendingBalance(String msg);

  void onFailureMessageUpdatePendingBalance(String error);
}
