import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/di/di.dart';
import 'package:IGO/src/models/responsemodel/product/calllogresponsemodel/ProductListResponseModel.dart';
import 'IProductListListener.dart';
import 'IntractorProductList.dart';

class PresenterProductList {
  AllApiRepository _allApiRepository;
  IProductListListener _iProductListListener;
  IntractorProductList _intractorProductList;

  PresenterProductList(this._iProductListListener) {
    _allApiRepository = new Injector().allApiRepository;
    _intractorProductList = new IntractorProductList(this);
  }

  void getProductList() {
    _intractorProductList.getProductList(
        _iProductListListener.parseGetProductDetailsRequestData());
  }

  void onSuccessResponseGetProductList(
      ProductListResponseModel productListResponseModel) {
    if (productListResponseModel.isSuccess) {
      _iProductListListener
          .onSuccessResponseGetProductList(productListResponseModel);
    } else {
      _iProductListListener
          .onFailureResponseGetProductList(productListResponseModel.message);
    }
  }

  void onFailureResponseGetProductList(String statusCode) {
    _iProductListListener.onFailureResponseGetProductList(statusCode);
  }
}
