class GetPendingBalanceResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> balanceDetails;

  GetPendingBalanceResponseModel(
      {this.code, this.isSuccess, this.message, this.balanceDetails});

  GetPendingBalanceResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        balanceDetails = map['balance_details'] ?? List();
}

class PendingBalanceDetails {
  String orderSummaryId;
  String orderId;
  String customerId;
  String customerName;
  String customerMobileNo;
  int totalAmount;
  String receivedAmount;
  int pendingAmount;
  String orderSummaryDate;

  PendingBalanceDetails({
    this.orderSummaryId,
    this.orderId,
    this.customerId,
    this.customerName,
    this.customerMobileNo,
    this.totalAmount,
    this.receivedAmount,
    this.pendingAmount,
    this.orderSummaryDate,
  });

  PendingBalanceDetails.fromMap(Map<String, dynamic> map)
      : orderSummaryId = map['order_summary_id'] ?? '',
        orderId = map['order_id'] ?? '',
        customerId = map['customer_id'] ?? '',
        customerName = map['customer_name'] ?? '',
        customerMobileNo = map['customer_mobile_no'] ?? '',
        totalAmount = map['total_amount'] ?? 0,
        receivedAmount = map['received_amount'] ?? '',
        pendingAmount = map['pending_amount'] ?? 0,
        orderSummaryDate = map['order_summary_date'] ?? '';
}
