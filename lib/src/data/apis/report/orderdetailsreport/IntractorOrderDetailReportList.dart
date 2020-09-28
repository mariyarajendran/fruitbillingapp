import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';

import 'PresenterOrderDetailReportList.dart';

class IntractorOrderDetailReportList {
  PresenterOrderDetailReportList _presenterOrderDetailReportList;
  AllApiRepository _allApiRepository;

  IntractorOrderDetailReportList(
      PresenterOrderDetailReportList _presenterOrderDetailReportList) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterOrderDetailReportList = _presenterOrderDetailReportList;
  }

  void getOverAllOrderDetailsReportList(Map requestData) {
    _allApiRepository
        .getOverAllOrderDetailedReports(requestData, 0)
        .then((data) {
      _presenterOrderDetailReportList
          .onSuccessResponseGetOrderDetailsReportList(data);
    }).catchError((error) {
      _presenterOrderDetailReportList
          .onFailureResponseGetOrderDetailsReportList(
              new FetchDataException(error.toString()).toString());
    });
  }
}
