class OrderReportResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> overAllReports;

  OrderReportResponseModel(
      {this.code, this.isSuccess, this.message, this.overAllReports});

  OrderReportResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        overAllReports = map['overall_reports'] ?? List();
}

class OverAllReports {
  String orderSummaryId;
  String orderId;
  String customerId;
  int totalAmount;
  String receivedAmount;
  int pendingAmount;
  String orderSummaryDate;
  String customerName;

  OverAllReports({
    this.orderSummaryId,
    this.orderId,
    this.customerId,
    this.totalAmount,
    this.receivedAmount,
    this.pendingAmount,
    this.orderSummaryDate,
    this.customerName,
  });

  OverAllReports.fromMap(Map<String, dynamic> map)
      : orderSummaryId = map['order_summary_id'] ?? '',
        orderId = map['order_id'] ?? '',
        customerId = map['customer_id'] ?? '',
        totalAmount = map['total_amount'] ?? 0,
        receivedAmount = map['received_amount'] ?? '',
        pendingAmount = map['pending_amount'] ?? 0,
        orderSummaryDate = map['order_summary_date'] ?? '',
        customerName = map['customer_name'] ?? '';
}
