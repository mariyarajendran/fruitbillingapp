import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import '../../../../utils/localizations.dart';
import 'IntractorAddProduct.dart';
import 'IAddProductListener.dart';

class PresenterAddProduct {
  AllApiRepository _allApiRepository;
  IAddProductListener _addProductListener;
  IntractorAddProduct _intractorAddProduct;

  PresenterAddProduct(this._addProductListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorAddProduct = new IntractorAddProduct(this);
  }

  void onSuccessResponseAddProduct(String msg) {
    _addProductListener.onSuccessResponseAddProduct(msg);
  }

  void onFailureMessageAddProduct(String error) {
    _addProductListener.onFailureMessageAddProduct(error);
  }

  void hitPostProductDataCall() {
    _intractorAddProduct
        .hitProductAddCall(_addProductListener.parseAddProductData());
  }

  void validateAddProductData() {
    if (_addProductListener.getProductName().isEmpty) {
      _addProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_name'));
    } else if (_addProductListener.getProductPrice().isEmpty) {
      _addProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_cost'));
    } else if (_addProductListener.getProductCode().isEmpty) {
      _addProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_code'));
    } else if (_addProductListener.getProductKg().isEmpty) {
      _addProductListener.errorValidationMgs(
          AppLocalizations.instance.text('key_enter_product_kg'));
    } else {
      _addProductListener.postAddProductData();
    }
  }
}
