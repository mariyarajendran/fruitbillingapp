import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/customer/updatecustomer/PresenterUpdateCustomer.dart';
import 'package:IGO/src/data/apis/product/updateproduct/PresenterUpdateProduct.dart';
import 'package:IGO/src/di/di.dart';

class IntractorUpdateCustomer {
  PresenterUpdateCustomer _presenterUpdateCustomer;
  AllApiRepository _allApiRepository;

  IntractorUpdateCustomer(PresenterUpdateCustomer _presenterUpdateCustomer) {
    this._presenterUpdateCustomer = _presenterUpdateCustomer;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitCustomerUpdateCall(Map mapProductData) {
    _allApiRepository.postUpdateCustomerDatas(mapProductData, 0).then((data) {
      if (data.isSuccess) {
        _presenterUpdateCustomer
            .onSuccessResponseUpdateCustomer(data.customerDetailsUpdate);
      } else {
        _presenterUpdateCustomer.onFailureMessageUpdateCustomer(data.message);
      }
    }).catchError((error) {
      _presenterUpdateCustomer
          .onFailureMessageUpdateCustomer(FetchDataException(error).toString());
    });
  }
}
