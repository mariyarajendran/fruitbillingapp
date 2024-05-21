class UpdateProductResponseModel {
  int code;
  bool isSuccess;
  String message;
  ProductDetailsUpdate productDetails;

  UpdateProductResponseModel(
      {this.code, this.isSuccess, this.message, this.productDetails});

  UpdateProductResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        productDetails = ProductDetailsUpdate.fromMap(map['product_details']);
}

class ProductDetailsUpdate {
  String productId;
  String productName;
  String productCost;
  String productStockKg;
  String productCode;
  String productDate;
  bool productStatus;

  ProductDetailsUpdate(
      {this.productId,
      this.productName,
      this.productCode,
      this.productStockKg,
      this.productCost,
      this.productDate,
      this.productStatus});

  ProductDetailsUpdate.fromMap(Map<String, dynamic> map)
      : productId = map['product_id'] ?? '',
        productName = map['product_name'] ?? '',
        productCost = map['product_cost'] ?? '',
        productStockKg = map['product_stock_kg'] ?? '',
        productCode = map['product_code'] ?? '',
        productStatus = map['product_status'] ?? false,
        productDate = map['product_date'] ?? '';
}
