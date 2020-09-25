import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';
import 'PresenterProductList.dart';

class IntractorProductList {
  PresenterProductList _presenterProductList;
  AllApiRepository _allApiRepository;

  IntractorProductList(PresenterProductList _presenterProductList) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterProductList = _presenterProductList;
  }

  void getProductList(Map requestData) {
    _allApiRepository.getProductListData(requestData,0).then((data) {
      _presenterProductList.onSuccessResponseGetProductList(data);
    }).catchError((error) {
      _presenterProductList.onFailureResponseGetProductList(
          new FetchDataException(error.toString()).toString());
    });
  }
}
