class OrderDetailsReportResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> overAllDetailReports;

  OrderDetailsReportResponseModel(
      {this.code, this.isSuccess, this.message, this.overAllDetailReports});

  OrderDetailsReportResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        overAllDetailReports = map['overall_reports_details'] ?? List();
}

class OverAllDetailReports {
  String purchaseDetailId;
  String orderId;
  String customerId;
  String productId;
  String productName;
  String productCost;
  String productStockKg;
  String productCode;
  String productDate;
  String purchaseDetailsDate;

  OverAllDetailReports({
    this.purchaseDetailId,
    this.orderId,
    this.customerId,
    this.productId,
    this.productName,
    this.productCost,
    this.productStockKg,
    this.productCode,
    this.productDate,
    this.purchaseDetailsDate,
  });

  OverAllDetailReports.fromMap(Map<String, dynamic> map)
      : purchaseDetailId = map['purchase_detail_id'] ?? '',
        orderId = map['order_id'] ?? '',
        customerId = map['customer_id'] ?? '',
        productId = map['product_id'] ?? '',
        productName = map['product_name'] ?? '',
        productCost = map['product_cost'] ?? '',
        productStockKg = map['product_stock_kg'] ?? '',
        productCode = map['product_code'] ?? '',
        productDate = map['product_date'] ?? '',
        purchaseDetailsDate = map['purchase_detail_date'] ?? '';
}
