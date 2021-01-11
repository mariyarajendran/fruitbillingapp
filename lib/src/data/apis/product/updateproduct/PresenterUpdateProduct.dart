import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IUpdateProductListener.dart';
import 'package:IGO/src/data/apis/product/updateproduct/IntractorUpdateProduct.dart';
import 'package:IGO/src/di/di.dart';
import 'package:IGO/src/models/responsemodel/product/updateproduct/UpdateProductResponseModel.dart';

import '../../../../utils/localizations.dart';

class PresenterUpdateProduct {
  AllApiRepository _allApiRepository;
  IUpdateProductListener _updateProductListener;
  IntractorUpdateProduct _intractorUpdateProduct;

  PresenterUpdateProduct(this._updateProductListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorUpdateProduct = new IntractorUpdateProduct(this);
  }

  void onSuccessResponseUpdateProduct(
      UpdateProductResponseModel updateProductResponseModel) {
    _updateProductListener
        .onSuccessResponseUpdateProduct(updateProductResponseModel);
  }

  void onFailureMessageUpdateProduct(String error) {
    _updateProductListener.onFailureMessageUpdateProduct(error);
  }

  void hitUpdateProductDataCall() {
    _intractorUpdateProduct
        .hitProductUpdateCall(_updateProductListener.parseUpdateProductData());
  }

  void validateUpdateProductData(bool status) {
    if (status) {
      if (_updateProductListener.getProductNameUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_previous_balance_hint'));
      } else if (_updateProductListener.getProductCostUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_previous_balance'));
      } else {
        _updateProductListener.postUpdateProductData();
      }
    } else {
      if (_updateProductListener.getProductNameUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_product_name'));
      } else if (_updateProductListener.getProductCostUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_product_cost'));
      } else if (_updateProductListener.getProductCodeUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_product_code'));
      } else if (_updateProductListener.getProductStockKgUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_enter_product_kg'));
      } else if (_updateProductListener.getProductStatusUpdate().isEmpty) {
        _updateProductListener.errorValidationMgs(
            AppLocalizations.instance.text('key_product_status'));
      } else {
        _updateProductListener.postUpdateProductData();
      }
    }
  }
}
