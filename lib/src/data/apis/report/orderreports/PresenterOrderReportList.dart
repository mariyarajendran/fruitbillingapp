import 'package:IGO/src/data/apis/report/orderreports/IOrderReportListener.dart';
import 'package:IGO/src/models/responsemodel/report/orderreport/OrderReportResponseModel.dart';
import 'IntractorOrderReportList.dart';

class PresenterOrderReportList {
  IOrderReportListener _iOrderReportListener;
  IntractorOrderReportList _intractorOrderReportList;

  PresenterOrderReportList(this._iOrderReportListener) {
    _intractorOrderReportList = new IntractorOrderReportList(this);
  }

  void getOrderReportList() {
    _intractorOrderReportList.getOverAllOrderReportList(
        _iOrderReportListener.parseGetOverAllOrderRequestData());
  }

  void onSuccessResponseGetOrderReportList(
      OrderReportResponseModel orderReportResponseModel) {
    List<OverAllReports> overAllReportsList = [];
    overAllReportsList = (orderReportResponseModel.overAllReports)
        .map((datas) => new OverAllReports.fromMap(datas))
        .toList();
    _iOrderReportListener
        .onSuccessResponseGetOverAllOrderList(overAllReportsList);
  }

  void onFailureResponseGetOrderReportList(String statusCode) {
    _iOrderReportListener.onFailureResponseGetOverAllOrderList(statusCode);
  }
}
