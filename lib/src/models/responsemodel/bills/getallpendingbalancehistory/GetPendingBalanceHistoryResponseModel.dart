class GetPendingBalanceHistoryResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> balanceDetails;

  GetPendingBalanceHistoryResponseModel(
      {this.code, this.isSuccess, this.message, this.balanceDetails});

  GetPendingBalanceHistoryResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        balanceDetails = map['balance_details'] ?? List();
}

class PendingBalanceHistoryDetails {
  String orderSummaryId;
  String orderId;
  String customerId;
  String totalAmount;
  int receivedAmount;
  String pendingAmount;
  String orderPendingHistoryDate;

  PendingBalanceHistoryDetails({
    this.orderSummaryId,
    this.orderId,
    this.customerId,
    this.totalAmount,
    this.receivedAmount,
    this.pendingAmount,
    this.orderPendingHistoryDate,
  });

  PendingBalanceHistoryDetails.fromMap(Map<String, dynamic> map)
      : orderSummaryId = map['order_summary_id'] ?? '',
        orderId = map['order_id'] ?? '',
        customerId = map['customer_id'] ?? '',
        totalAmount = map['order_summary_pending_amount'] ?? 0,
        receivedAmount = map['order_pending_history_received'] ?? '',
        pendingAmount = map['order_pending_history_pending'] ?? 0,
        orderPendingHistoryDate = map['order_pending_history_date'] ?? '';
}
