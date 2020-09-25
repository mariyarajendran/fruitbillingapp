import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/product/updateproduct/PresenterUpdateProduct.dart';
import 'package:IGO/src/di/di.dart';

class IntractorUpdateProduct {
  PresenterUpdateProduct _presenterUpdateProduct;
  AllApiRepository _allApiRepository;

  IntractorUpdateProduct(PresenterUpdateProduct _presenterUpdateProduct) {
    this._presenterUpdateProduct = _presenterUpdateProduct;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitProductUpdateCall(Map mapProductData) {
    _allApiRepository.postUpdateProductDatas(mapProductData, 0).then((data) {
      if (data.isSuccess) {
        _presenterUpdateProduct
            .onSuccessResponseUpdateProduct(data.productDetails);
      } else {
        _presenterUpdateProduct.onFailureMessageUpdateProduct(data.message);
      }
    }).catchError((error) {
      _presenterUpdateProduct
          .onFailureMessageUpdateProduct(FetchDataException(error).toString());
    });
  }
}
