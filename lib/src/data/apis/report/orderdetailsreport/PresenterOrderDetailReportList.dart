import 'package:IGO/src/data/apis/report/orderdetailsreport/IOrderDetailReportListener.dart';
import 'package:IGO/src/models/responsemodel/report/orderdetailsreport/OrderDetailsReportResponseModel.dart';
import 'IntractorOrderDetailReportList.dart';

class PresenterOrderDetailReportList {
  IOrderDetailReportListener _orderDetailReportListener;
  IntractorOrderDetailReportList _intractorOrderDetailReportList;

  PresenterOrderDetailReportList(this._orderDetailReportListener) {
    _intractorOrderDetailReportList = new IntractorOrderDetailReportList(this);
  }

  void getOrderDetailsReportList() {
    _intractorOrderDetailReportList.getOverAllOrderDetailsReportList(
        _orderDetailReportListener.parseGetProductDetailsRequestData());
  }

  void onSuccessResponseGetOrderDetailsReportList(
      OrderDetailsReportResponseModel orderDetailsReportResponseModel) {
    if (orderDetailsReportResponseModel.isSuccess) {
//      List<OverAllDetailReports> overAllDetailReports = [];
//      overAllDetailReports =
//          (orderDetailsReportResponseModel.overAllDetailReports)
//              .map((datas) => new OverAllDetailReports.fromMap(datas))
//              .toList();
      _orderDetailReportListener.onSuccessResponseGetOverAllDetailsOrderList(
          orderDetailsReportResponseModel);
    } else {
      _orderDetailReportListener.onFailureResponseGetOverAllDetailsOrderList(
          orderDetailsReportResponseModel.message);
    }
  }

  void onFailureResponseGetOrderDetailsReportList(String statusCode) {
    _orderDetailReportListener
        .onFailureResponseGetOverAllDetailsOrderList(statusCode);
  }
}
