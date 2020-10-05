class UpdateCustomerResponseModel {
  int code;
  bool isSuccess;
  String message;
  CustomerDetailsUpdate customerDetailsUpdate;

  UpdateCustomerResponseModel(
      {this.code, this.isSuccess, this.message, this.customerDetailsUpdate});

  UpdateCustomerResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        customerDetailsUpdate =
            CustomerDetailsUpdate.fromMap(map['customer_details']);
}

class CustomerDetailsUpdate {
  String customerId;
  String customerName;
  String customerBillingName;
  String customerAddress;
  String customerMobileNumber;
  String customerWhatsAppNo;
  bool customerStatus;

  CustomerDetailsUpdate(
      {this.customerId,
      this.customerName,
      this.customerBillingName,
      this.customerAddress,
      this.customerMobileNumber,
      this.customerWhatsAppNo,
      this.customerStatus});

  CustomerDetailsUpdate.fromMap(Map<String, dynamic> map)
      : customerId = map['customer_id'] ?? '',
        customerName = map['customer_name'] ?? '',
        customerBillingName = map['customer_billing_name'] ?? 0,
        customerAddress = map['customer_address'] ?? 0,
        customerMobileNumber = map['customer_mobile_no'] ?? '',
        customerWhatsAppNo = map['customer_whatsapp_no'] ?? '',
        customerStatus = map['customer_status'] ?? false;
}
