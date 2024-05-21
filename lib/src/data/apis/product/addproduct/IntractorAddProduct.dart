import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterAddProduct.dart';

class IntractorAddProduct {
  PresenterAddProduct _presenterAddProduct;
  AllApiRepository _allApiRepository;

  IntractorAddProduct(PresenterAddProduct _presenterAddProduct) {
    this._presenterAddProduct = _presenterAddProduct;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitProductAddCall(Map mapProductData) {
    _allApiRepository.postAddProductDatas(mapProductData, 0).then((data) {
      if (data.success) {
        _presenterAddProduct.onSuccessResponseAddProduct(data.message);
      } else {
        _presenterAddProduct.onFailureMessageAddProduct(data.message);
      }
    }).catchError((error) {
      _presenterAddProduct
          .onFailureMessageAddProduct(FetchDataException(error).toString());
    });
  }
}
