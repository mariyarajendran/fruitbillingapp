import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class CustomerListResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> customerDetails;

  CustomerListResponseModel(
      {this.code, this.isSuccess, this.message, this.customerDetails});

  CustomerListResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        customerDetails = map['customer_details'] ?? List();
}

class CustomerDetails {
  String customerId;
  String customerName;
  String customerWhatsappNo;
  String customerBillingName;
  String customerMobileNo;
  String customerAddress;
  String customerDate;
  bool isExpanded = false;
  int totalCost = 0;
  int totalKiloGrams = 0;
  TextEditingController textEditingController;

  CustomerDetails(
      {this.customerId,
      this.customerName,
      this.customerAddress,
      this.customerBillingName,
      this.customerMobileNo,
      this.customerWhatsappNo,
      this.customerDate,
      this.isExpanded,
      this.totalCost,
      this.textEditingController});

  CustomerDetails.fromMap(Map<String, dynamic> map)
      : customerId = map['customer_id'] ?? '',
        customerName = map['customer_name'] ?? '',
        customerBillingName = map['customer_billing_name'] ?? '',
        customerAddress = map['customer_address'] ?? '',
        customerMobileNo = map['customer_mobile_no'] ?? '',
        customerWhatsappNo = map['customer_whatsapp_no'] ?? '',
        customerDate = map['customer_date'] ?? '';
}
