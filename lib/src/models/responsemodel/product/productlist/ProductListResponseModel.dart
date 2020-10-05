import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class ProductListResponseModel {
  int code;
  bool isSuccess;
  String message;
  List<dynamic> productDetails;

  ProductListResponseModel(
      {this.code, this.isSuccess, this.message, this.productDetails});

  ProductListResponseModel.fromMap(Map<String, dynamic> map)
      : code = map['code'] ?? '',
        isSuccess = map['isSuccess'] ?? false,
        message = map['message'] ?? '',
        productDetails = map['product_details'] ?? List();
}

class ProductDetails {
  String productId;
  String productName;
  int productCost;
  String productDate;
  int productStockKg;
  String productCode;
  bool isExpanded = false;
  int totalCost = 0;
  int totalKiloGrams = 0;
  TextEditingController textEditingController;

  ProductDetails(
      {this.productId,
      this.productName,
      this.productCode,
      this.productDate,
      this.productStockKg,
      this.productCost,
      this.isExpanded,
      this.totalCost,
      this.textEditingController});

  ProductDetails.fromMap(Map<String, dynamic> map)
      : productId = map['product_id'] ?? '',
        productName = map['product_name'] ?? '',
        productCost = map['product_cost'] ?? 0,
        productDate = map['product_date'] ?? '',
        productStockKg = map['product_stock_kg'] ?? 0,
        productCode = map['product_code'] ?? '';
}
