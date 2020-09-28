class OrderDetailsReportResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> overAllDetailReports;
  CustomerDetails customerDetails;

  OrderDetailsReportResponseModel(
      {this.code, this.isSuccess, this.message, this.overAllDetailReports});

  OrderDetailsReportResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        customerDetails =
            CustomerDetails.fromMap(map['customer_details']) ?? {},
        overAllDetailReports = map['overall_reports_details'] ?? List();
}

class CustomerDetails {
  String customerId;
  String customerName;
  String customerBillingName;
  String customerAddress;
  String customerMobileNo;
  String customerWhatsappNo;
  String customerDate;

  CustomerDetails({
    this.customerId,
    this.customerName,
    this.customerBillingName,
    this.customerAddress,
    this.customerMobileNo,
    this.customerWhatsappNo,
    this.customerDate,
  });

  CustomerDetails.fromMap(Map<String, dynamic> map)
      : customerId = map['customer_id'] ?? '',
        customerName = map['customer_name'] ?? '',
        customerBillingName = map['customer_billing_name'] ?? '',
        customerAddress = map['customer_address'] ?? '',
        customerMobileNo = map['customer_mobile_no'] ?? '',
        customerWhatsappNo = map['customer_whatsapp_no'] ?? '',
        customerDate = map['customer_date'] ?? '';
}

class OverAllDetailReports {
  String purchaseDetailId;
  String orderId;
  String customerId;
  String productId;
  String productName;
  String productCost;
  String productStockKg;
  String productTotalCost;
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
    this.productTotalCost,
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
        productTotalCost = map['product_total_cost'] ?? '',
        productCode = map['product_code'] ?? '',
        productDate = map['product_date'] ?? '',
        purchaseDetailsDate = map['purchase_detail_date'] ?? '';
}
