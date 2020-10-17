import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';

abstract class IUpdateProductListener {
  String getProductIdUpdate();

  String getProductNameUpdate();

  String getProductCostUpdate();

  String getProductStockKgUpdate();

  String getProductCodeUpdate();

  String getProductStatusUpdate();

  Map parseUpdateProductData();

  void postUpdateProductData();

  void errorValidationMgs(String error);

  void onSuccessResponseUpdateProduct(UpdateProductResponseModel updateProductResponseModel);

  void onFailureMessageUpdateProduct(String error);
}
