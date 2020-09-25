import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/data/apis/bills/updatependingbalance/PresenterUpdatePendingBalance.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterSaveBillData.dart';

class IntractorSaveBill {
  PresenterSaveBillData _presenterSaveBillData;
  AllApiRepository _allApiRepository;

  IntractorSaveBill(PresenterSaveBillData _presenterSaveBillData) {
    this._presenterSaveBillData = _presenterSaveBillData;
    _allApiRepository = new Injector().allApiRepository;
  }

  void hitSaveBillCall(Map mapProductData) {
    _allApiRepository.postPlaceOrder(mapProductData, 0).then((data) {
      if (data.success) {
        _presenterSaveBillData.onSuccessResponseSaveBill(data.message);
      } else {
        _presenterSaveBillData.onFailureMessageSaveBill(data.message);
      }
    }).catchError((error) {
      _presenterSaveBillData
          .onFailureMessageSaveBill(FetchDataException(error).toString());
    });
  }
}
