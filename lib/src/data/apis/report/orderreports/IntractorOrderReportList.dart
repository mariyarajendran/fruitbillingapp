import 'package:IGO/src/data/AllApiRepository.dart';
import 'package:IGO/src/data/FetchDataException.dart';
import 'package:IGO/src/di/di.dart';
import 'PresenterOrderReportList.dart';

class IntractorOrderReportList {
  PresenterOrderReportList _presenterOrderReportList;
  AllApiRepository _allApiRepository;

  IntractorOrderReportList(PresenterOrderReportList _presenterOrderReportList) {
    _allApiRepository = new Injector().allApiRepository;
    this._presenterOrderReportList = _presenterOrderReportList;
  }

  void getOverAllOrderReportList(Map requestData) {
    _allApiRepository.getOverAllOrderReports(requestData, 0).then((data) {
      _presenterOrderReportList.onSuccessResponseGetOrderReportList(data);
    }).catchError((error) {
      _presenterOrderReportList.onFailureResponseGetOrderReportList(
          new FetchDataException(error.toString()).toString());
    });
  }
}
