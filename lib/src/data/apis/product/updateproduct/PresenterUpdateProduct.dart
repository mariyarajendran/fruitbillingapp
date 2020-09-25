import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IUpdateProductListener.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IntractorUpdateProduct.dart';
import 'package:IGO/src/di/di.dart';
import 'file:///D:/CGS/PBXAPP/igo-flutter/lib/src/utils/localizations.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';

class PresenterUpdateProduct {
  AllApiRepository _allApiRepository;
  IUpdateProductListener _updateProductListener;
  IntractorUpdateProduct _intractorUpdateProduct;

  PresenterUpdateProduct(this._updateProductListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorUpdateProduct = new IntractorUpdateProduct(this);
  }

  void onSuccessResponseUpdateProduct(ProductDetailsUpdate productDetails) {
    _updateProductListener.onSuccessResponseUpdateProduct(productDetails);
  }

  void onFailureMessageUpdateProduct(String error) {
    _updateProductListener.onFailureMessageUpdateProduct(error);
  }

  void hitPostProductDataCall() {
    _intractorUpdateProduct
        .hitProductUpdateCall(_updateProductListener.parseUpdateProductData());
  }

  void validateUpdateProductData() {
    if (_updateProductListener.getProductName().isEmpty) {
      _updateProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_name'));
    } else if (_updateProductListener.getProductCost().isEmpty) {
      _updateProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_cost'));
    } else if (_updateProductListener.getProductCode().isEmpty) {
      _updateProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_code'));
    } else if (_updateProductListener.getProductStockKg().isEmpty) {
      _updateProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_kg'));
    } else if (_updateProductListener.getProductStatus().isEmpty) {
      _updateProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_product_status'));
    } else {
      _updateProductListener.postUpdateProductData();
    }
  }
}
