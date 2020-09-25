
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterAddCustomer.dart';

class IntractorAddCustomer {
  PresenterAddCustomer _presenterAddCustomer;
  AllApiRepository _allApiRepository;

  IntractorAddCustomer(PresenterAddCustomer _presenterAddCustomer) {
    this._presenterAddCustomer = _presenterAddCustomer;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitCustomerAddCall(Map mapProductData) {
    _allApiRepository.postAddCustomerDatas(mapProductData, 0).then((data) {
      if (data.success) {
        _presenterAddCustomer.onSuccessResponseAddProduct(data.message);
      } else {
        _presenterAddCustomer.onFailureMessageAddProduct(data.message);
      }
    }).catchError((error) {
      _presenterAddCustomer
          .onFailureMessageAddProduct(FetchDataException(error).toString());
    });
  }
}
