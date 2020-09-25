
import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterCustomerList.dart';

class IntractorCustomerList {
  PresenterCustomerList _presenterCustomerList;
  AllApiRepository _allApiRepository;

  IntractorCustomerList(PresenterCustomerList _presenterCustomerList) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterCustomerList = _presenterCustomerList;
  }

  void getCustomerList(Map requestData) {
    _allApiRepository.getCustomerListData(requestData, 0).then((data) {
      _presenterCustomerList.onSuccessResponseGetCustomerList(data);
    }).catchError((error) {
      _presenterCustomerList.onFailureResponseGetCustomerList(
          new FetchDataException(error.toString()).toString());
    });
  }
}
